class fifo_sequencer extends uvm_sequencer#(fifo_sequence_item);
  `uvm_component_utils(fifo_sequencer)

  function new(string name = "fifo_sequencer",uvm_component parent = null);
    super.new(name,parent);
  endfunction
endclass

class virtual_sequencer extends uvm_sequencer#(fifo_sequence_item);
  `uvm_component_utils(virtual_sequencer)
  fifo_sequencer seqr_1;
  fifo_sequencer seqr_2;

  function new(string name = "virtual_sequencer",uvm_component parent = null);
    super.new(name,parent);
  endfunction
endclass
