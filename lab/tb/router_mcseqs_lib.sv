class router_simple_mcseq extends uvm_sequence;
  `uvm_object_utils(router_simple_mcseq)
  `uvm_declare_p_sequencer(router_mcsequencer)
  
  yapp_exhaustive_seq all;
  /*
  yapp_012_seq yapp_012;
  yapp_rand_seq rseq;
  */

  hbus_small_packet_seq small_cfg;
  hbus_read_max_pkt_seq rd1;
  hbus_set_default_regs_seq large_cfg;
  hbus_read_max_pkt_seq rd2;

  
  function new(string name="router_simple_mcseq");
    super.new(name);
  endfunction
  
  task pre_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif

    if (phase != null) begin
      phase.raise_objection(this, $sformatf("%s start", get_type_name()));
      `uvm_info(get_type_name(), "raise objection", UVM_MEDIUM)
    end

  endtask : pre_body

  task post_body();
    uvm_phase phase;
`ifdef UVM_VERSION_1_2
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase != null) begin
      phase.drop_objection(this, $sformatf("%s done", get_type_name()));
      `uvm_info(get_type_name(), "drop objection", UVM_MEDIUM)
    end
  endtask : post_body

  virtual task body();
    
    `uvm_do_on(small_cfg, p_sequencer.hbus_seqr)
    `uvm_do_on(rd1, p_sequencer.hbus_seqr)
    //`uvm_do_on(yapp_012, p_sequencer.yapp_seqr)
    //`uvm_do_on(yapp_012, p_sequencer.yapp_seqr)
    `uvm_do_on(all, p_sequencer.yapp_seqr)
    `uvm_do_on(large_cfg, p_sequencer.hbus_seqr)
    `uvm_do_on(rd2, p_sequencer.hbus_seqr)
    //`uvm_do_on(rseq, p_sequencer.yapp_seqr, {rseq.count == 6;})

    //rseq = yapp_rand_seq::type_id::create("rseq");
    //rseq.count = 6;
    //rseq.start(p_sequencer.yapp_seqr);


    
  endtask : body


endclass : router_simple_mcseq