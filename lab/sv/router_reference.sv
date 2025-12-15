
class router_reference extends uvm_component;

    `uvm_component_utils(router_reference)

    `uvm_analysis_imp_decl(_yapp)
    `uvm_analysis_imp_decl(_hbus)

    //import
    uvm_analysis_imp_yapp#(yapp_packet, router_reference) yapp_imp;
    uvm_analysis_imp_hbus#(hbus_transaction, router_reference) hbus_imp;

    //export
    uvm_analysis_port#(yapp_packet) valid_yapp_port;


    int unsigned maxpktsize = 20;
    bit router_en = 1;

    int packets_dropped = 0;
    int dropped_disabled = 0;
    int dropped_oversize = 0;
    int dropped_illegal_addr = 0;



    function new(string name = "", uvm_component parent = null);
        super.new(name, parent);
        hbus_imp = new("hbus_imp", this);
        yapp_imp = new("yapp_imp", this);

        valid_yapp_port = new("valid_yapp_port", this);
    endfunction : new
    
    function void write_hbus(hbus_transaction tr);
        `uvm_info(get_type_name(),
        $sformatf("Received HBUS Transaction : /n%s", tr.sprint()), UVM_HIGH)
        if (tr.hwr_rd == HBUS_WRITE)
            case (tr.haddr)
                'h1000 : maxpktsize = tr.hdata;
                'h1001 : router_en = tr.hdata;
            endcase
    endfunction : write_hbus

    function void write_yapp(yapp_packet pkt);
        `uvm_info(get_type_name(),
        $sformatf("Received Input YAPP Packet : /n%s", pkt.sprint()), UVM_HIGH)
        if (!router_en) begin
            dropped_disabled++;
            packets_dropped++;
            return;
        end
        if (pkt.length > maxpktsize) begin
            dropped_oversize++;
            packets_dropped++;
            return;
        end
        if (pkt.addr > 2) begin
            dropped_illegal_addr++;
            packets_dropped++;
            return;
        end

        // אם הכל תקין – שלח ל-scoreboard
        valid_yapp_port.write(pkt);
    endfunction

    function void report_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "----------------------------------------------------", UVM_LOW)
        `uvm_info(get_type_name(), "               ROUTER REFERENCE SUMMARY             ", UVM_LOW)
        `uvm_info(get_type_name(), "----------------------------------------------------", UVM_LOW)

        `uvm_info(get_type_name(),
        $sformatf("Packets Dropped = %0d :",
                packets_dropped), UVM_LOW)
        
        `uvm_info(get_type_name(),
        $sformatf("%0d - dropped_disabled,", dropped_disabled), UVM_LOW)
        `uvm_info(get_type_name(),
        $sformatf("%0d - dropped_oversize,", dropped_oversize), UVM_LOW)
        `uvm_info(get_type_name(),
        $sformatf("%0d - dropped_illegal_addr,", dropped_illegal_addr), UVM_LOW)
        /*
        `uvm_info(get_type_name(),
        $sformatf("CHANNEL 1:      Packets = %0d, Matched = %0d, Miscompared = %0d, Dropped = %0d",
                packets_ch1, compare_ch1, miscompare_ch1, dropped_ch1), UVM_LOW)
        
        `uvm_info(get_type_name(),
        $sformatf("CHANNEL 2:      Packets = %0d, Matched = %0d, Miscompared = %0d, Dropped = %0d",
                    packets_ch2, compare_ch2, miscompare_ch2, dropped_ch2), UVM_LOW)


    `uvm_info(get_type_name(),
        $sformatf("TOTAL SUMMARY:  In=%0d  Matched=%0d  Miscompared=%0d  Dropped=%0d",
                packets_in, (compare_ch0 + compare_ch1 + compare_ch2),
                (miscompare_ch0 + miscompare_ch1 + miscompare_ch2),
                (dropped_ch0 + dropped_ch1 + dropped_ch2)), UVM_LOW)

    `uvm_info(get_type_name(), "----------------------------------------------------", UVM_LOW)


        if((miscompare_ch0 + miscompare_ch1 + miscompare_ch2 + dropped_ch0 + dropped_ch1 + dropped_ch2) > 0)
        `uvm_error(get_type_name(), "Status:     ===== Simulation FAILED =====\n")
        else
        `uvm_info(get_type_name(), "Status:     ===== Simulation PASSED  (O_O) =====\n", UVM_NONE)
*/
    endfunction : report_phase




endclass : router_reference