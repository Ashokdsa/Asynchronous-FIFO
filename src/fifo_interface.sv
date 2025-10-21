`include "defines.svh"
interface fifo_intf(input logic wclk,rclk);
  logic winc,rinc;
  logic wrstn,rrstn;
  logic [`DATA - 1:0]wdata;
  logic [`DATA - 1:0]rdata;
  logic wfull,rempty;

  clocking wdrv_cb @(posedge wclk);
    output winc,wrstn;
    output wdata;
    //input wfull;
  endclocking

  clocking rdrv_cb @(posedge rclk);
    output rinc,rrstn;
    //input rempty;
  endclocking

  clocking wmon_cb @(posedge wclk);
    input winc,wrstn;
    input wdata;
    input wfull;
  endclocking

  clocking rmon_cb @(posedge rclk);
    input rinc,rrstn;
    input rdata;
    input rempty;
  endclocking
endinterface
