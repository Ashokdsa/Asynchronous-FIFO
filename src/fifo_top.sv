`timescale 1ns/1ps
`include "defines.svh"
//`include "design.v" //FIFO DESIGN
`include "fifo_interface.sv"
`include "fifo_assertion.sv"
module fifo_top extends uvm_top;
  bit w_clk,r_clk;
  real dw = (500/`WCLK) ,dr = (500/`RCLK);

  always #dw w_clk = ~w_clk; 

  always #dr r_clk = ~r_clk; 

  fifo_intf intf(.w_clk(w_clk),.r_clk(r_clk));

  bind fifo_intf fifo_assertion assertion(.*);

  //design DUT();

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
