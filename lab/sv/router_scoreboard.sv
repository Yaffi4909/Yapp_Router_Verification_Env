class router_scoreboard extends  uvm_scoreboard;
  `uvm_component_utils(router_scoreboard)

/*
  `uvm_component_utils_begin(router_scoreboard)
    `uvm_field_enum(comp_t, compare_policy, UVM_ALL_ON)
  `uvm_component_utils_end
*/
  `uvm_analysis_imp_decl(_yapp)
  `uvm_analysis_imp_decl(_chan0)
  `uvm_analysis_imp_decl(_chan1)
  `uvm_analysis_imp_decl(_chan2)

  uvm_analysis_imp_yapp  #(yapp_packet, router_scoreboard) sb_yapp_in;
  uvm_analysis_imp_chan0 #(channel_packet, router_scoreboard) sb_chan0;
  uvm_analysis_imp_chan1 #(channel_packet, router_scoreboard) sb_chan1;
  uvm_analysis_imp_chan2 #(channel_packet, router_scoreboard) sb_chan2;

  yapp_packet sb_queue0[$];
  yapp_packet sb_queue1[$];
  yapp_packet sb_queue2[$];

  int packets_in, in_dropped;
  int packets_ch0, compare_ch0, miscompare_ch0, dropped_ch0;
  int packets_ch1, compare_ch1, miscompare_ch1, dropped_ch1;
  int packets_ch2, compare_ch2, miscompare_ch2, dropped_ch2;

  //comp compare_policy = UVM;

  function new (string name , uvm_component parent);
    super.new(name, parent);

    sb_yapp_in = new("sb_yapp_in", this);
    sb_chan0 = new("sb_chan0", this);
    sb_chan1 = new("sb_chan1", this);
    sb_chan2 = new("sb_chan2", this);
  endfunction : new

  virtual function void write_yapp(yapp_packet packet);
    yapp_packet sb_packet;
    $cast(sb_packet, packet.clone());
    packets_in++;

    case(sb_packet.addr)
      2'b00:begin
          sb_queue0.push_back(sb_packet);
          `uvm_info(get_type_name(), "Added packet to scoreboard 0", UVM_HIGH)
        end
      2'b01:begin
          sb_queue1.push_back(sb_packet);
          `uvm_info(get_type_name(), "Added packet to scoreboard 1", UVM_HIGH)
        end
      2'b10:begin
          sb_queue2.push_back(sb_packet);
          `uvm_info(get_type_name(), "Added packet to scoreboard 2", UVM_HIGH)
        end
      default:begin
          `uvm_info(get_type_name(), $sformatf("Packet dropped: Bad Address=%d\n%s", sb_packet.addr, sb_packet.sprint()), UVM_LOW)
          in_dropped++;
        end
    endcase
  endfunction : write_yapp

  function void write_chan0(channel_packet packet);
    bit pktcompare;
    yapp_packet sb_packet;
    packets_ch0++;
    if(sb_queue0.size() == 0)begin
      `uvm_error(get_type_name(),
      $sformatf("Scoreboard Error [EMPTY]: Received Unexpected Channel_0 Packet!\n%s",
                packet.sprint()))
      dropped_ch0++;
      return;
    end

    // השוואה לפי מדיניות (UVM comparer או ==)
    //if (compare_policy == UVM) begin
    //  pktcompare = comp_uvm(sb_queue0[0], packet);
    //end
    //else begin
      pktcompare = comp_equal(sb_queue0[0], packet);
    //end

    // תוצאה
    if (pktcompare) begin
      void'(sb_queue0.pop_front()); // הסרה מהתור במקרה של התאמה
      `uvm_info(get_type_name(),
        $sformatf("Scoreboard Compare Match: Channel_0 Packet\n%s",
                  packet.sprint()),
        UVM_MEDIUM)
      compare_ch0++;
    end
    else begin
      sb_packet = sb_queue0[0]; // משאירים בתור לצורך דוח/בדיקה
      `uvm_warning(get_type_name(),
        $sformatf("Scoreboard Error [MISMATCH]: Received Channel_0 Packet:\n%s\nExpected Channel_0 Packet:\n%s",
                  packet.sprint(), sb_packet.sprint()))
      miscompare_ch0++;
    end
  endfunction

  // Channel 1 Packet Check (write) implementation
  virtual function void write_chan1(channel_packet packet);
    bit         pktcompare;
    yapp_packet sb_packet;
    packets_ch1++;

    if (sb_queue1.size() == 0) begin
      `uvm_error(get_type_name(),
        $sformatf("Scoreboard Error [EMPTY]: Received Unexpected Channel_1 Packet!\n%s",
                  packet.sprint()))
      dropped_ch1++;
      return;
    end

    //if (compare_policy == UVM) begin
    //  pktcompare = comp_uvm(sb_queue1[0], packet);
    //end
    //else begin
      pktcompare = comp_equal(sb_queue1[0], packet);
    //end

    if (pktcompare) begin
      void'(sb_queue1.pop_front());
      `uvm_info(get_type_name(),
        $sformatf("Scoreboard Compare Match: Channel_1 Packet\n%s",
                  packet.sprint()),
        UVM_MEDIUM)
      compare_ch1++;
    end
    else begin
      sb_packet = sb_queue1[0];
      `uvm_warning(get_type_name(),
        $sformatf("Scoreboard Error [MISMATCH]: Received Channel_1 Packet:\n%s\nExpected Channel_1 Packet:\n%s",
                  packet.sprint(), sb_packet.sprint()))
      miscompare_ch1++;
    end
  endfunction

  // Channel 2 Packet Check (write) implementation
  virtual function void write_chan2(channel_packet packet);
    bit         pktcompare;
    yapp_packet sb_packet;
    packets_ch2++;

    if (sb_queue2.size() == 0) begin
      `uvm_error(get_type_name(),
        $sformatf("Scoreboard Error [EMPTY]: Received Unexpected Channel_2 Packet!\n%s",
                  packet.sprint()))
      dropped_ch2++;
      return;
    end

    //if (compare_policy == UVM) begin
    //  pktcompare = comp_uvm(sb_queue2[0], packet);
    //end
    //else begin
      pktcompare = comp_equal(sb_queue2[0], packet);
    //end

    if (pktcompare) begin
      void'(sb_queue2.pop_front());
      `uvm_info(get_type_name(),
        $sformatf("Scoreboard Compare Match: Channel_2 Packet\n%s",
                  packet.sprint()),
        UVM_MEDIUM)
      compare_ch2++;
    end
    else begin
      sb_packet = sb_queue2[0];
      `uvm_warning(get_type_name(),
        $sformatf("Scoreboard Error [MISMATCH]: Received Channel_2 Packet:\n%s\nExpected Channel_2 Packet:\n%s",
                  packet.sprint(), sb_packet.sprint()))
      miscompare_ch2++;
    end
  endfunction



/*
  function bit comp_uvm(input yapp_packet packet, input channel_packet cp, uvm_comparer comparer = null);
    string str;
    if(comparer == null)
      comparer = new();
    comp_uvm = comparer.compare_fields("addr", yp.addr, cp.addr, 2);
    comp_uvm &= comparer.compare_fields("length", yp.length, cp.length, 6);
    foreach(yp.payload[i])begin
      str.itoa(i);
      comp_uvm &= comparer.compare_fields({"payload[", str, "]"});




  endfunction
*/

  function void report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), "----------------------------------------------------", UVM_LOW)
    `uvm_info(get_type_name(), "               ROUTER SCOREBOARD SUMMARY             ", UVM_LOW)
    `uvm_info(get_type_name(), "----------------------------------------------------", UVM_LOW)

    `uvm_info(get_type_name(),
      $sformatf("YAPP INPUT:     Packets In = %0d, Dropped = %0d",
              packets_in, in_dropped), UVM_LOW)
    
    `uvm_info(get_type_name(),
    $sformatf("CHANNEL 0:      Packets = %0d, Matched = %0d, Miscompared = %0d, Dropped = %0d",
              packets_ch0, compare_ch0, miscompare_ch0, dropped_ch0), UVM_LOW)
    
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

  endfunction : report_phase

  
  function bit comp_equal (input yapp_packet yp, input channel_packet cp);
      // returns first mismatch only
      if (yp.addr != cp.addr) begin
        `uvm_error("PKT_COMPARE",$sformatf("Address mismatch YAPP %0d Chan %0d",yp.addr,cp.addr))
        return(0);
      end
      if (yp.length != cp.length) begin
        `uvm_error("PKT_COMPARE",$sformatf("Length mismatch YAPP %0d Chan %0d",yp.length,cp.length))
        return(0);
      end
      foreach (yp.payload [i])
        if (yp.payload[i] != cp.payload[i]) begin
          `uvm_error("PKT_COMPARE",$sformatf("Payload[%0d] mismatch YAPP %0d Chan %0d",i,yp.payload[i],cp.payload[i]))
          return(0);
        end
      if (yp.parity != cp.parity) begin
        `uvm_error("PKT_COMPARE",$sformatf("Parity mismatch YAPP %0d Chan %0d",yp.parity,cp.parity))
        return(0);
      end
      return(1);
   endfunction




endclass : router_scoreboard