
/*
class router_scoreboard_fifo extends uvm_scoreboard;
    `uvm_component_utils(router_scoreboard_fifo)

    // FIFOs for each data source
    uvm_tlm_analysis_fifo#(yapp_packet)    yapp_fifo;
    uvm_tlm_analysis_fifo#(hbus_transaction) hbus_fifo;
    uvm_tlm_analysis_fifo#(channel_packet) chan0_fifo;
    uvm_tlm_analysis_fifo#(channel_packet) chan1_fifo;
    uvm_tlm_analysis_fifo#(channel_packet) chan2_fifo;

    comp_t compare_policy = UVM;

    int unsigned maxpktsize = 20;
    bit router_en = 1;
    int packets_in = 0;
    int packets_dropped = 0;
    int dropped_disabled = 0;
    int dropped_oversize = 0;
    int bad_addr_packets = 0;
    int packets_valid = 0;
    pack

/*
    // Get ports for reading
    uvm_get_port#(yapp_packet)    yapp_get;
    uvm_get_port#(hbus_transaction) hbus_get;
    uvm_get_port#(channel_packet) chan0_get;
    uvm_get_port#(channel_packet) chan1_get;
    uvm_get_port#(channel_packet) chan2_get;
*/
    function new(string name, uvm_component parent);
        super.new(name, parent);

        // Create FIFOs
        yapp_fifo = new("yapp_fifo", this);
        hbus_fifo = new("hbus_fifo", this);
        chan0_fifo = new("chan0_fifo", this);
        chan1_fifo = new("chan1_fifo", this);
        chan2_fifo = new("chan2_fifo", this);
    endfunction

    task run_phase(uvm_phase phase);
        fork
            check_packet();
            update_rger();
        join
    endtask

    task update_rger;
        hbus_transaction hb;
        forever begin
            hbus_fifo.get_peek_export.get(hb);
            `uvm_info(get_type_name(),
            $sformatf("Scoreboard : Received HBUS Transaction : /n%s", hb.sprint()), UVM_HIGH)
            if(hb.hwr_rd == HBUS_WRITE)
            case(hb.haddr)
                'h1000 : maxpktsize = hb.hdata;
                'h1001 : router_en = hb.hdata;
            endcase
        end
    endtask : update_rger

    task check_packet;
        yapp_packet yapp_pkt;
        channel_packet chan_pkt;
        bit valid;
        forever begin 
            yapp_fifo.get_peek_export(yapp_pkt);
            `uvm_info(get_type_name(),
            $sformatf("Scoreboard : Received YAPP Transaction : /n%s", yapp_pkt.sprint()), UVM_MEDIUM)
            packets_in++;
            valid = 1'b1;
            if(yapp_pkt.addr == 3)begin
                bad_addr_packets++;
                packets_dropped++;
                `uvm_info("Scoreboard :  YAPP Packet Dropped [BAD ADDRESS]", UVM_LOW)
                valid = 1'b0;
            end
            else if(router_en == 1 && yapp_pkt.length > maxpktsize) begin
                dropped_oversize++;
                packets_dropped++;
                `uvm_info("Scoreboard :  YAPP Packet Dropped [OVERSIZE]", UVM_HIGH)
                valid = 1'b0;
            end
            else if(router_en == 0) begin
                dropped_disabled++;
                packets_dropped++;
                `uvm_info("Scoreboard :  YAPP Packet Dropped [DISABLED]", UVM_HIGH)
                valid = 1'b0;
            end
        end
        while ( valid == 1'b0);
        bit pktcompare;
        packets_valid++;
        packets_ch[yapp_pkt.addr]++;

        case (yapp_pkt.addr)
            0 : chan0_fifo.get_peek_export.get(chan_pkt);
            1 : chan1_fifo.get_peek_export.get(chan_pkt);
            2 : chan2_fifo.get_peek_export.get(chan_pkt);
        endcase

        `uvm_info("Scoreboard :  Packet Got from chan analysis fifo", UVM_LOW)

        pktcompare = comp_equal(yapp_pkt, chan_pkt);
        if(pktcompare) begin
            `uvm_info(get_type_name(),
            $sformatf("Scoreboard compare matched channel: %0d", chan_pkt.addr), UVM_HIGH)
            compare_ch[chan_pkt.addr]++;
        end

    endtask : check_packet

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        

        // Create get ports
        yapp_get  = new("yapp_get",  this);
        hbus_get  = new("hbus_get",  this);
        chan0_get = new("chan0_get", this);
        chan1_get = new("chan1_get", this);
        chan2_get = new("chan2_get", this);
    endfunction
endclass
*/