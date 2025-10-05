`include "defines.svh"
interface fifo_assertion(wclk,rclk,winc,rinc,wrstn,rrstn,wfull,wempty,wdata,rdata);
  input logic wclk,rclk,winc,rinc,wrstn,rrstn,wfull,wempty;
  input logic [`DATA-1:0] wdata,rdata;
endinterface
