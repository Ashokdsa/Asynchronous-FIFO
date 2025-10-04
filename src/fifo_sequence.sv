class fifo_base_sequence extends uvm_sequence#(fifo_sequence_item);
  fifo_sequence_item seq;
  int qu[$];
  `uvm_object_utils(fifo_base_sequence)

  function new(string name = "fifo_sequence");
    super.new(name);
  endfunction

  task body();
    `uvm_do(seq)
  endtask
endclass

class virtual_sequence extends uvm_sequence#(fifo_sequence_item);
  int qu[$];
  `uvm_object_utils(virtual_sequence)

  function new(string name = "virtual_sequence");
    super.new(name);
  endfunction

  task body();
    `uvm_do(seq)
  endtask
endclass
