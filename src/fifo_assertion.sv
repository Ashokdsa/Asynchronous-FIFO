`include "defines.svh"
interface fifo_assertion(wclk,rclk,winc,rinc,wrstn,rrstn,wfull,rempty,wdata,rdata);
  input logic wclk,rclk,winc,rinc,wrstn,rrstn,wfull,rempty;
  input logic [`DATA-1:0] wdata,rdata;

  property valid_w_ip;
    @(posedge wclk)
    !$isunknown({winc,wrstn,wdata});
  endproperty
  assert property(valid_w_ip) `uvm_info("ASSERTION","WRITE INPUTS ARE VALID",UVM_DEBUG) else `uvm_error("ASSERTION","WRITE INPUTS INVALID")
  
  property valid_r_ip;
    @(posedge rclk)
    !$isunknown({rinc,rrstn});
  endproperty
  assert property(valid_r_ip) `uvm_info("ASSERTION","READ INPUTS ARE VALID",UVM_DEBUG) else `uvm_error("ASSERTION","READ INPUTS INVALID")
  
  property write_after_full;
    @(posedge wclk) disable iff(!wrstn)
    $past(wfull) |-> wfull ##0 winc;
  endproperty
  assert property(write_after_full) `uvm_error("ASSERTION","INPUTTING AFTER FULL") else `uvm_info("ASSERTION","FULL AND NO INPUT",UVM_DEBUG)
  
  property read_while_empty;
    @(posedge rclk) disable iff(!rrstn)
    $past(rempty) |-> rempty ##0 rinc;
  endproperty
  assert property(read_while_empty) `uvm_error("ASSERTION","READ WHILE EMPTY") else `uvm_info("ASSERTION","READ NORMALLY",UVM_DEBUG)
  
  assert property(@(posedge wclk) wfull) `uvm_warning("ASSERTION","FIFO FULL") else `uvm_info("ASSERTION","THERE'S SPACE IN FIFO",UVM_DEBUG)
  
  assert property(@(posedge rclk) rempty) `uvm_warning("ASSERTION","FIFO EMPTY") else `uvm_info("ASSERTION","CONTENT IN FIFO",UVM_DEBUG)

  assert property(@(posedge wclk) wrstn) `uvm_info("ASSERTION","NO WRITE RESET TRIGGERED",UVM_DEBUG) else `uvm_warning("ASSERTION","WRITE RESET TRIGGERED")

  assert property(@(posedge rclk) rrstn) `uvm_info("ASSERTION","NO READ RESET TRIGGERED",UVM_DEBUG) else `uvm_warning("ASSERTION","READ RESET TRIGGERED")

endinterface
