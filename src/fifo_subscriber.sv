`include "defines.svh"
typedef enum{READ,WRITE}para;
`uvm_analysis_imp_decl(_subs_r)
//COVERGROUPS
covergroup input_cg(para p);
endgroup

covergroup output_cg(para p);
endgroup

//SUBSCRIBER
class fifo_subscriber extends uvm_subscriber#(fifo_sequence_item);
  `uvm_component_utils(fifo_subscriber)

  fifo_sequence_item mon_w,mon_r;
  uvm_analysis_imp_subs_r#(fifo_subscriber,fifo_sequence_item)r_item_collect_export;


  input_cg w_in_cg, r_in_cg;
  output_cg w_out_cg, r_out_cg;

  function new(string name = "fifo_subscriber",uvm_component parent = null);
    super.new(name,parent);
    w_in_cg = new(WRITE);
    r_in_cg = new(READ);
    w_out_cg = new(WRITE);
    r_out_cg = new(READ);
    r_item_collect_export = new("r_collect",this);
  endfunction

  virtual function void write(fifo_sequence_item t);
    mon_w = t;
    w_in_cg.sample();
    w_out_cg.sample();
    `uvm_info(get_name,"WRITE INPUTS AND OUTPUTS RECIEVED",UVM_LOW)
  endfunction

  virtual function void write_subs_r(fifo_sequence_item rd);
    mon_r = rd;
    r_in_cg.sample();
    r_out_cg.sample();
    `uvm_info(get_name,"READ INPUTS AND OUTPUTS RECIEVED",UVM_LOW)
  endfunction

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    $display("---\t\tFUNCTIONAL COVERAGE\t\t---");
    $display("INPUT COVERAGE = %0d\nOUTPUT COVERAGE = %0d\n",(w_in_cg.get_coverage()+r_in_cg.get_coverage())/2,(w_out_cg.get_coverage()+r_out_cg.get_coverage())/2);
  endfunction
endclass

