
class router_module_env extends uvm_env;
    `uvm_component_utils(router_module_env)

    router_reference refm;
    router_scoreboard sb;

    // ADD in class router_module_env
    uvm_analysis_export#(yapp_packet)        yapp_exp;
    uvm_analysis_export#(hbus_transaction)   hbus_exp;
    uvm_analysis_export#(channel_packet)     chan0_exp;
    uvm_analysis_export#(channel_packet)     chan1_exp;
    uvm_analysis_export#(channel_packet)     chan2_exp;


    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        refm = router_reference::type_id::create("refm", this);
        sb   = router_scoreboard::type_id::create("sb", this);

        // ADD in build_phase()
        yapp_exp  = new("yapp_exp",  this);
        hbus_exp  = new("hbus_exp",  this);
        chan0_exp = new("chan0_exp", this);
        chan1_exp = new("chan1_exp", this);
        chan2_exp = new("chan2_exp", this);

    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        yapp_exp.connect(refm.yapp_imp);
        hbus_exp.connect(refm.hbus_imp);

        chan0_exp.connect(sb.sb_chan0);
        chan1_exp.connect(sb.sb_chan1);
        chan2_exp.connect(sb.sb_chan2);

        refm.valid_yapp_port.connect(sb.sb_yapp_in);
    endfunction



endclass : router_module_env