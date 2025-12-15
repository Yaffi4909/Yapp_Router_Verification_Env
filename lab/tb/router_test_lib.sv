class base_test extends uvm_test;

	`uvm_component_utils(base_test)

	function new(string name, uvm_component parent);
		super.new(name,parent);
	endfunction:new

	router_tb tb;

	function void build_phase(uvm_phase phase);
	 super.build_phase(phase);
	 uvm_config_int::set( this, "*", "recording_detail", 1);
	 tb = router_tb::type_id::create("tb", this);	  
	 `uvm_info("MSG","Test build phase executed",UVM_HIGH);
	endfunction:build_phase

	task run_phase (uvm_phase phase); 
          uvm_objection obj = phase.get_objection();
          obj.set_drain_time(this, 200ns);
        endtask:run_phase

	function void end_of_elaboration_phase(uvm_phase phase);
	  uvm_top.print_topology();
        endfunction: end_of_elaboration_phase

	function void check_phase (uvm_phase phase);
          check_config_usage();
        endfunction:check_phase


endclass:base_test

/*
class short_packet_test extends base_test;
  `uvm_component_utils(short_packet_test)
  
  function new (string name , uvm_component parent);
    super.new(name, parent);
  endfunction:new

  function void build_phase(uvm_phase phase);
    yapp_packet::type_id::set_type_override(short_yapp_packet::get_type());
    uvm_config_wrapper::set(this, "tb.yapp.tx_agent.sequencer.run_phase","default_sequence", yapp_5_packets::get_type());
    super.build_phase(phase);

  endfunction:build_phase

endclass:short_packet_test

class set_config_test extends base_test;
  `uvm_component_utils(set_config_test)

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction:new

  function void build_phase(uvm_phase phase);
    uvm_config_int::set(this, "tb.yapp.tx_agent", "is_active", UVM_PASSIVE);
    super.build_phase(phase);
  endfunction:build_phase

endclass:set_config_test

    
class incr_payload_test extends base_test;
 `uvm_component_utils(incr_payload_test)

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction:new

  function void build_phase(uvm_phase phase);
    yapp_packet::type_id::set_type_override(short_yapp_packet::get_type());
    uvm_config_wrapper::set(this, "tb.yapp.tx_agent.sequencer.run_phase",
	                   "default_sequence",yapp_incr_payload_seq::type_id::get() );
    super.build_phase(phase);
  endfunction:build_phase

endclass:incr_payload_test
  

class exhaustive_seq_test extends base_test;
  `uvm_component_utils(exhaustive_seq_test)

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction:new

  function void build_phase(uvm_phase phase);
    yapp_packet::type_id::set_type_override(short_yapp_packet::get_type());
    uvm_config_wrapper::set(this, "tb.yapp.tx_agent.sequencer.run_phase",
	                   "default_sequence",yapp_exhaustive_seq::type_id::get() );
    super.build_phase(phase);
  endfunction:build_phase

endclass:exhaustive_seq_test


class short_yapp_012 extends base_test;
  `uvm_component_utils(short_yapp_012)

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction:new

  function void build_phase(uvm_phase phase);
    yapp_packet::type_id::set_type_override(short_yapp_packet::get_type());
    uvm_config_wrapper::set(this, "tb.yapp.tx_agent.sequencer.run_phase",
	                   "default_sequence",yapp_012_seq::type_id::get() );
    super.build_phase(phase);
  endfunction:build_phase

endclass:short_yapp_012
*/

class simple_test extends base_test;
  `uvm_component_utils(simple_test)
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);

    set_type_override_by_type(yapp_packet::get_type(), short_yapp_packet::get_type());
    uvm_config_wrapper::set(this, "tb.yapp.tx_agent.sequencer.run_phase",
	                   "default_sequence",yapp_012_seq::type_id::get() );
    uvm_config_wrapper::set(this, "tb.clock_and_reset.agent.sequencer.run_phase",
	                   "default_sequence",clk10_rst5_seq::type_id::get() );
    uvm_config_wrapper::set(this, "tb.chan*.rx_agent.sequencer.run_phase",
	                   "default_sequence",channel_rx_resp_seq::type_id::get() );


    super.build_phase(phase);
  endfunction:build_phase

endclass :simple_test


class test_uvc_integration extends base_test;
  `uvm_component_utils(test_uvc_integration)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);

  endfunction

endclass : test_uvc_integration



class mcseq_test extends base_test;
  `uvm_component_utils(mcseq_test)
  
  function new(string name="mcseq_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);

    yapp_packet::type_id::set_type_override(short_yapp_packet::get_type());


    uvm_config_wrapper::set(this, "tb.clock_and_reset.agent.sequencer.run_phase",
	                   "default_sequence",clk10_rst5_seq::type_id::get());
    uvm_config_wrapper::set(this, "tb.mcseqr.run_phase",
	                   "default_sequence",router_simple_mcseq::type_id::get() );
    uvm_config_wrapper::set(this, "tb.chan?.rx_agent.sequencer.run_phase",
	                   "default_sequence",channel_rx_resp_seq::type_id::get() );

    super.build_phase(phase);


  endfunction
endclass : mcseq_test


class  uvm_reset_test extends base_test;

    uvm_reg_hw_reset_seq reset_seq;

  // component macro
  `uvm_component_utils(uvm_reset_test)

  // component constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
      uvm_config_wrapper::set(this, "tb.clock_and_reset.agent.sequencer.run_phase",
                      "default_sequence",clk10_rst5_seq::type_id::get());
      uvm_config_wrapper::set(this, "tb.mcseqr.run_phase",
                      "default_sequence",router_simple_mcseq::type_id::get() );
      uvm_config_wrapper::set(this, "tb.chan?.rx_agent.sequencer.run_phase",
                      "default_sequence",channel_rx_resp_seq::type_id::get() );

      uvm_reg::include_coverage("*", UVM_NO_COVERAGE);
      reset_seq = uvm_reg_hw_reset_seq::type_id::create("uvm_reset_seq");
      super.build_phase(phase);
  endfunction : build_phase

  virtual task run_phase (uvm_phase phase);
     phase.raise_objection(this, "Raising Objection to run uvm built in reset test");
     // Set the model property of the sequence to our Register Model instance
     // Update the RHS of this assignment to match your instance names. Syntax is:
     //  <testbench instance>.<register model instance>
     reset_seq.model = tb.yapp_rm;
     // Execute the sequence (sequencer is already set in the testbench)
     reset_seq.start(null);
     phase.drop_objection(this," Dropping Objection to uvm built reset test finished");
  endtask

endclass : uvm_reset_test




class  reg_access_test extends base_test;

    uvm_reg_hw_reset_seq reset_seq;
    yapp_regs_c regs;

  `uvm_component_utils(reg_access_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
  
      uvm_config_wrapper::set(this, "tb.clock_and_reset.agent.sequencer.run_phase",
                      "default_sequence",clk10_rst5_seq::type_id::get());
                      /*
      uvm_config_wrapper::set(this, "tb.mcseqr.run_phase",
                      "default_sequence",router_simple_mcseq::type_id::get() );
      uvm_config_wrapper::set(this, "tb.chan?.rx_agent.sequencer.run_phase",
                      "default_sequence",channel_rx_resp_seq::type_id::get() );
*/
      uvm_reg::include_coverage("*", UVM_NO_COVERAGE);
      reset_seq = uvm_reg_hw_reset_seq::type_id::create("uvm_reset_seq");
      super.build_phase(phase);

  endfunction : build_phase

  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);

    regs = tb.yapp_rm.router_yapp_regs;
    if (regs == null)
      `uvm_fatal("NO_REGS", "Failed to bind regs block handle (tb.yapp_rm.router_yapp_regs)")
  endfunction

  virtual task run_phase (uvm_phase phase);
    uvm_status_e    status;
    uvm_reg_data_t  rd, wr;
    
    phase.raise_objection(this, "Raising Objection to run uvm built in reset test");

    reset_seq.model = tb.yapp_rm;
    reset_seq.start(null);


    //RW test addr0_cnt_en uvm_reg_field RW en_reg[4:4]=1'h0       :
    wr = 1;

    // write:
    `uvm_info("***************ACC", $sformatf("RW test: frontdoor WRITE addr0_cnt_en <= 0x%0h", wr), UVM_NONE)
    regs.en_reg.addr0_cnt_en.write(status, wr, .path(UVM_FRONTDOOR));
    if (status != UVM_IS_OK) `uvm_error("ACC", "write(addr0_cnt_en) failed")

    // peek:
    regs.en_reg.addr0_cnt_en.peek(status, rd);
    `uvm_info("***************ACC", $sformatf("Backdoor PEEK addr0_cnt_en => 0x%0h", rd), UVM_NONE)
    if (rd !== wr)  `uvm_error("***************ACC", $sformatf("PEEK mismatch: got 0x%0h expected 0x%0h", rd, wr))

    // poke:
    wr = 0;
    `uvm_info("***************ACC", $sformatf("Backdoor POKE addr0_cnt_en <= 0x%0h", wr), UVM_NONE)
    regs.en_reg.addr0_cnt_en.poke(status, wr);
    if (status != UVM_IS_OK) `uvm_error("***************ACC", "poke(addr0_cnt_en) failed")

    // read:
    regs.en_reg.addr0_cnt_en.read(status, rd, .path(UVM_FRONTDOOR));
    `uvm_info("***************ACC", $sformatf("Frontdoor READ addr0_cnt_en => 0x%0h", rd), UVM_NONE)
    if (rd !== wr)  `uvm_error("***************ACC", $sformatf("READ mismatch: got 0x%0h expected 0x%0h", rd, wr))


    //RO test addr0_cnt_reg  :
    wr = 'h77;

    // poke:
    `uvm_info("***************ACC", $sformatf("RO test: backdoor POKE addr0_cnt_reg <= 0x%0h", wr), UVM_NONE)
    regs.addr0_cnt_reg.poke(status, wr);
    if (status != UVM_IS_OK) `uvm_error("***************ACC", "poke(addr0_cnt_reg) failed")

    // read:
    regs.addr0_cnt_reg.read(status, rd, .path(UVM_FRONTDOOR));
    `uvm_info("***************ACC", $sformatf("Frontdoor READ addr0_cnt_reg => 0x%0h", rd), UVM_NONE)
    if (rd !== wr)  `uvm_error("***************ACC", $sformatf("RO read mismatch: got 0x%0h expected 0x%0h", rd, wr))

    // write:
    wr = 'h11;
    `uvm_info("***************ACC", $sformatf("Frontdoor WRITE (attempt) addr0_cnt_reg <= 0x%0h", wr), UVM_NONE)
    regs.addr0_cnt_reg.write(status, wr, .path(UVM_FRONTDOOR));

    // peek:
    regs.addr0_cnt_reg.peek(status, rd);
    `uvm_info("***************ACC", $sformatf("Backdoor PEEK addr0_cnt_reg => 0x%0h (should remain 0x%0h)", rd, 'h77), UVM_NONE)
    if (rd !== 'h77) `uvm_error("***************ACC", $sformatf("RO should not change on frontdoor write: got 0x%0h", rd))

    

    phase.drop_objection(this," Dropping Objection to uvm built reset test finished");
  endtask

endclass : reg_access_test





class  reg_function_test extends base_test;

    uvm_reg_hw_reset_seq reset_seq;
    yapp_regs_c regs;
    yapp_tx_sequencer yapp_seqr;
    yapp_012_seq seq012;


  `uvm_component_utils(reg_function_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);

      seq012 = yapp_012_seq::type_id::create("seq012");

      uvm_config_db#(uvm_object_wrapper)::set(
        this, "tb.chan?.rx_agent.sequencer.run_phase", "default_sequence",
        channel_rx_resp_seq::type_id::get());



      uvm_config_wrapper::set(this, "tb.clock_and_reset.agent.sequencer.run_phase",
                      "default_sequence",clk10_rst5_seq::type_id::get());
 /*                     
      uvm_config_wrapper::set(this, "tb.mcseqr.run_phase",
                      "default_sequence",router_simple_mcseq::type_id::get() );
     
*/
      uvm_reg::include_coverage("*", UVM_NO_COVERAGE);
      reset_seq = uvm_reg_hw_reset_seq::type_id::create("uvm_reset_seq");
      super.build_phase(phase);

  endfunction : build_phase


  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    yapp_seqr = tb.yapp.tx_agent.sequencer;
    if (yapp_seqr == null)
      `uvm_fatal("NO_YAPP_SEQR", "Failed to bind yapp TX sequencer (tb.yapp.tx_agent.sequencer)")
  endfunction





  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);

    regs = tb.yapp_rm.router_yapp_regs;
    if (regs == null)
      `uvm_fatal("NO_REGS", "Failed to bind regs block handle (tb.yapp_rm.router_yapp_regs)")
  endfunction


  virtual task run_phase (uvm_phase phase);
    uvm_status_e    status;
    uvm_reg_data_t  val;
    uvm_reg_data_t  a0, a1, a2, a3;  

    
    phase.raise_objection(this, "Raising Objection to run uvm built in reset test");

    reset_seq.model = tb.yapp_rm;
    reset_seq.start(null);

    //1
    `uvm_info("FUNC", "FD WRITE en_reg.router_en <= 1 (others remain 0)", UVM_NONE)
    regs.en_reg.router_en.write(status, 1, .path(UVM_FRONTDOOR));
    if (status != UVM_IS_OK) `uvm_error("FUNC", "write(en_reg.router_en) failed")
    
    //2
    regs.en_reg.read(status, val, .path(UVM_FRONTDOOR));
    `uvm_info("FUNC", $sformatf("FD READ en_reg => 0x%0h", val), UVM_NONE)
    if (val != 1)
      `uvm_error("FUNC", $sformatf("router_en bit expected 1, got %0d", val))

    //3
    `uvm_info("FUNC", "Start seq012 once", UVM_NONE)
    seq012.start(yapp_seqr);

    //4
    
    regs.addr0_cnt_reg.read(status, a0, .path(UVM_FRONTDOOR));
    regs.addr1_cnt_reg.read(status, a1, .path(UVM_FRONTDOOR));
    regs.addr2_cnt_reg.read(status, a2, .path(UVM_FRONTDOOR));
    regs.addr3_cnt_reg.read(status, a3, .path(UVM_FRONTDOOR));
    `uvm_info("FUNC", $sformatf("Counters (partial enable): a0=%0d a1=%0d a2=%0d a3=%0d", a0,a1,a2,a3), UVM_NONE)

    if (a0!=0 || a1!=0 || a2!=0 || a3!=0)
      `uvm_error("FUNC", "Counters should NOT increment with only router_en=1")

    //5
    `uvm_info("FUNC", "Enable ALL en_reg fields (router_en/parity/oversize/addr0..3)=1 (FD field writes)", UVM_NONE)
    regs.en_reg.write(status, 8'hFF, .path(UVM_FRONTDOOR));

    //6
    `uvm_info("FUNC", "Start seq012 twice", UVM_NONE)
    seq012.start(yapp_seqr);
    seq012.start(yapp_seqr);

    //7
    regs.addr0_cnt_reg.read(status, a0, .path(UVM_FRONTDOOR));
    regs.addr1_cnt_reg.read(status, a1, .path(UVM_FRONTDOOR));
    regs.addr2_cnt_reg.read(status, a2, .path(UVM_FRONTDOOR));
    regs.addr3_cnt_reg.read(status, a3, .path(UVM_FRONTDOOR));
    `uvm_info("FUNC", $sformatf("Counters (all enabled, after 2 runs): a0=%0d a1=%0d a2=%0d a3=%0d", a0,a1,a2,a3), UVM_NONE)

    // התאמה לציפייה של seq012: חבילה לכל יעד 0/1/2 בכל ריצה → אחרי 2 ריצות: 2/2/2/0
    if (a0!=2 || a1!=2 || a2!=2 || a3!=0)
      `uvm_error("FUNC", $sformatf("Unexpected counters (expected 2,2,2,0): a0=%0d a1=%0d a2=%0d a3=%0d", a0,a1,a2,a3))

    //8
    regs.parity_err_cnt_reg.read(status, val, .path(UVM_FRONTDOOR));
    `uvm_info("FUNC", $sformatf("parity_err_cnt_reg = %0d", val), UVM_NONE)

    regs.oversized_pkt_cnt_reg.read(status, val, .path(UVM_FRONTDOOR));
    `uvm_info("FUNC", $sformatf("oversized_pkt_cnt_reg = %0d", val), UVM_NONE)

    

    phase.drop_objection(this," Dropping Objection to uvm built reset test finished");
  endtask

endclass : reg_function_test

