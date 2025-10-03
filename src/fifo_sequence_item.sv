`include "defines.svh"
class fifo_sequence_item extends uvm_sequence_item;
  `uvm_object_utils(fifo_sequence_item)
  rand logic winc,rinc;
  rand logic wrstn,rrstn;
  rand logic [`DATA - 1:0]wdata;
  logic [`DATA - 1:0]rdata;
  logic wfull,rempty;

  constraint normal
  {
    if(!wfull)
      soft winc == 1;
    if(!rempty)
      soft rinc == 1;
    soft wrstn == 1;
    soft rrstn == 1;
  }

  function new(string name = "sequence_item");
    super.new(name);
  endfunction
endclass
