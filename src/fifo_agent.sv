class fifo_w_agent extends uvm_agent;
  fifo_wdriver drv;
  fifo_wmonitor mon;
  fifo_sequencer seqr;
  `uvm_component_utils(fifo_w_agent)

  function new(string name = "fifo_w_agent",uvm_component parent = null);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    mon = fifo_wmonitor::type_id::create("mon",this);
    if(get_is_active() == UVM_ACTIVE)
    begin
      drv = fifo_wdriver::type_id::create("drv",this);
      seqr = fifo_sequencer::type_id::create("seqr",this);
    end
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(get_is_active() == UVM_ACTIVE)
      drv.seq_item_port.connect(seqr.seq_item_export);
  endfunction

endclass

class fifo_r_agent extends uvm_agent;
  fifo_rdriver drv;
  fifo_rmonitor mon;
  fifo_sequencer seqr;
  `uvm_component_utils(fifo_agent)

  function new(string name = "fifo_r_agent",uvm_component parent = null);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    mon = fifo_rmonitor::type_id::create("mon",this);
    if(get_is_active() == UVM_ACTIVE)
    begin
      drv = fifo_rdriver::type_id::create("drv",this);
      seqr = fifo_sequencer::type_id::create("seqr",this);
    end
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(get_is_active() == UVM_ACTIVE)
      drv.seq_item_port.connect(seq.seq_item_export);
  endfunction

endclass
