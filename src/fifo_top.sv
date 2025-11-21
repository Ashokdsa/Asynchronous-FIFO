`timescale 1ns/1ps
`include "fifo_interface.sv"
`include "fifo_pkg.svh"
import uvm_pkg::*;
import fifo_pkg::*;
`include "/fetools/work_area/frontend/Batch_10/vedavyas/design_verification/async_fifo_project/FIFO.v" //FIFO DESIGN
`include "fifo_assertion.sv"
module fifo_top;
  bit w_clk,r_clk;
  real dw = (500/`WCLK) ,dr = (500/`RCLK);

  always #dw w_clk = ~w_clk; 

  always #dr r_clk = ~r_clk; 

  fifo_intf intf(.wclk(w_clk),.rclk(r_clk));

  bind fifo_intf fifo_assertion assertion(.*);

  FIFO DUT(.rdata(intf.rdata),.wfull(intf.wfull),.rempty(intf.rempty),.wdata(intf.wdata),.winc(intf.winc),.wclk(intf.wclk),.wrst_n(intf.wrstn),.rinc(intf.rinc),.rclk(intf.rclk),.rrst_n(intf.rrstn));

  initial begin
    intf.wrstn = 0;
    repeat(2)@(posedge w_clk);
  end

  initial begin
    intf.rrstn = 0;
    repeat(2)@(posedge r_clk);
  end

  initial begin
    uvm_config_db#(virtual fifo_intf)::set(null,"*","vif",intf);
    run_test("fifo_test");
    $finish;
  end

  initial begin
    $dumpfile("fifo_wave.vcd");
    $dumpvars(0);
  end
endmodule
