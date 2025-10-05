class fifo_environment extends uvm_env;
  fifo_w_agent w_agnt;
  fifo_r_agent r_agnt;
  fifo_scoreboard scb;
  fifo_subscriber subs;
  virtual_sequencer vseqr;
  `uvm_component_utils(fifo_environment)

  function new(string name = "fifo_environment",uvm_component parent = null);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    //NOT NECESSARY AS DEFAULT IS UVM_ACTIVE
    uvm_config_db#(uvm_active_passive_enum)::set(this,"w_agnt","is_active",UVM_ACTIVE);
    uvm_config_db#(uvm_active_passive_enum)::set(this,"r_agnt","is_active",UVM_ACTIVE);

    //2 AGENT CREATION
    w_agnt = fifo_w_agent::type_id::create("w_agnt",this);
    r_agnt = fifo_r_agent::type_id::create("r_agnt",this);

    //SCOREBOARD CREATION
    scb = fifo_scoreboard::type_id::create("scb",this);

    //SUBSCRIBER CREATION
    subs = fifo_subscriber::type_id::create("subs",this);

    //VSEQUENCER CREATION
    vseqr = virtual_sequencer::type_id::create("vseqr",this);

    //CONNECTING THE VSEQUENCER SEQUENCERS TO THE ACTUAL SEQUENCERS
    vseqr.seqr_1 = w_agnt.seqr;
    vseqr.seqr_2 = r_agnt.seqr;
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    //SCOREBOARD CONNECTION
    w_agnt.mon.item_collected_port.connect(scb.w_item_collect_export);
    r_agnt.mon.item_collected_port.connect(scb.r_item_collect_export);
    //SUBSCRIBER CONNECTION
    w_agnt.mon.item_collected_port.connect(subs.analysis_export);
    r_agnt.mon.item_collected_port.connect(subs.r_item_collect_export);
  endfunction
endclass
