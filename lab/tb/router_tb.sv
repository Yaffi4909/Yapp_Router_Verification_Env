

class router_tb extends uvm_env;

	yapp_router_regs_t  yapp_rm;    // מודל הרגיסטרים
	hbus_reg_adapter    reg2hbus;   // adapter בין uvm_reg_sequence ל-HBUS


	`uvm_component_utils_begin(router_tb)
		`uvm_field_object(yapp_rm, UVM_ALL_ON) // מאקרו אוטומציה לשיחזור/השוואה/print
	`uvm_component_utils_end

	router_mcsequencer mcseqr;

	yapp_env yapp;

	channel_env chan0;
	channel_env chan1;
	channel_env chan2;

	hbus_env hbus;

	clock_and_reset_env clock_and_reset;

	//router_scoreboard scoreboard;
	router_module_env rtr_env;

	
	function new(string name, uvm_component parent);
          super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
	  super.build_phase(phase);
	  `uvm_info("MSG","Testbench build phase executed",UVM_HIGH);

	  yapp = yapp_env::type_id::create("yapp", this);
	  
	  uvm_config_int::set(this, "chan0", "channel_id", 0);
	  uvm_config_int::set(this, "chan1", "channel_id", 1);
	  uvm_config_int::set(this, "chan2", "channel_id", 2);
	  chan0 = channel_env::type_id::create("chan0", this);
	  chan1 = channel_env::type_id::create("chan1", this);
	  chan2 = channel_env::type_id::create("chan2", this);

	  uvm_config_int::set(this, "hbus", "num_masters", 1);
	  uvm_config_int::set(this, "hbus", "num_slaves", 0);
	  hbus = hbus_env::type_id::create("hbus", this);

	  clock_and_reset = clock_and_reset_env::type_id::create("clock_and_reset", this);
    
	  mcseqr = router_mcsequencer::type_id::create("mcseqr", this);

	  //scoreboard = router_scoreboard::type_id::create("scoreboard", this);
	  rtr_env = router_module_env::type_id::create("rtr_env", this);


	  //registers
	  yapp_rm = yapp_router_regs_t::type_id::create("yapp_rm", this);
      yapp_rm.build();
      yapp_rm.lock_model();
      yapp_rm.set_hdl_path_root("hw_top.dut");
      yapp_rm.default_map.set_auto_predict(1);
      reg2hbus = hbus_reg_adapter::type_id::create("reg2hbus", this);

	endfunction : build_phase


	function void connect_phase(uvm_phase phase);
	  	mcseqr.hbus_seqr = hbus.masters[0].sequencer;
	  	mcseqr.yapp_seqr = yapp.tx_agent.sequencer;

	   	yapp.tx_agent.monitor.item_collected_port.connect(rtr_env.yapp_exp);
	   	hbus.masters[0].monitor.item_collected_port.connect(rtr_env.hbus_exp);

	    chan0.rx_agent.monitor.item_collected_port.connect(rtr_env.chan0_exp);
		chan1.rx_agent.monitor.item_collected_port.connect(rtr_env.chan1_exp);
		chan2.rx_agent.monitor.item_collected_port.connect(rtr_env.chan2_exp);

		yapp_rm.default_map.set_sequencer(hbus.masters[0].sequencer, reg2hbus);




	endfunction:connect_phase


	

endclass:router_tb


