`include "defines.svh"
typedef enum{READ,WRITE}para;
`uvm_analysis_imp_decl(_subs_r)

//SUBSCRIBER
class fifo_subscriber extends uvm_subscriber#(fifo_sequence_item);
  `uvm_component_utils(fifo_subscriber)

  fifo_sequence_item mon_w,mon_r;
  uvm_analysis_imp_subs_r#(fifo_sequence_item,fifo_subscriber)r_item_collect_export;

  //COVERGROUPS
  covergroup write_cg;
    //INPUT
    WRSTN_cp: coverpoint mon_w.wrstn
              {
                bins normal = {1};
                bins reset = {0};
              }
    WDATA_cp: coverpoint mon_w.wdata
              {
                bins wval[3] = {[0:$]};
              }
    WINC_cp: coverpoint mon_w.winc;
    WRSTxINC: cross WRSTN_cp,WINC_cp
             {
               bins normal = binsof(WRSTN_cp.normal);
               bins special = binsof(WRSTN_cp.reset) && (binsof(WINC_cp) intersect {1});
             }
    //OUTPUT
    WFULL_cp: coverpoint mon_w.wfull;
    WFULLxINC: cross WFULL_cp,WINC_cp
               {
                 bins normal = (binsof(WFULL_cp) intersect {0}) || ((binsof(WFULL_cp) intersect {1}) && (binsof(WINC_cp) intersect {0}));
                 bins special = (binsof(WFULL_cp) intersect {1}) && (binsof(WINC_cp) intersect {1});
               }
  endgroup
  
  covergroup read_cg;
    //INPUT
    RRSTN_cp: coverpoint mon_r.rrstn
              {
                bins normal = {1};
                bins reset = {0};
              }
    RINC_cp: coverpoint mon_r.rinc;
    RRSTxINC: cross RRSTN_cp,RINC_cp
             {
               bins normal = binsof(RRSTN_cp.normal);
               bins special = binsof(RRSTN_cp.reset) && (binsof(RINC_cp) intersect {1});
             }
    //OUTPUT
    RDATA_cp: coverpoint mon_r.rdata
              {
                bins rval[3] = {[0:$]};
              }
    REMPTY_cp: coverpoint mon_r.rempty;
    REMPTYxINC: cross REMPTY_cp,RINC_cp
               {
                 bins normal = (binsof(REMPTY_cp) intersect {0}) || ((binsof(REMPTY_cp) intersect {1}) && (binsof(RINC_cp) intersect {0}));
                 bins special = (binsof(REMPTY_cp) intersect {1}) && (binsof(RINC_cp) intersect {1});
               }
  endgroup

  function new(string name = "fifo_subscriber",uvm_component parent = null);
    super.new(name,parent);
    r_item_collect_export = new("r_collect",this);
    write_cg = new();
    read_cg = new();
  endfunction

  virtual function void write(fifo_sequence_item t);
    mon_w = t;
    write_cg.sample();
    `uvm_info(get_name,"WRITE INPUTS AND OUTPUTS RECIEVED",UVM_LOW)
  endfunction

  virtual function void write_subs_r(fifo_sequence_item rd);
    mon_r = rd;
    read_cg.sample();
    `uvm_info(get_name,"READ INPUTS AND OUTPUTS RECIEVED",UVM_LOW)
  endfunction

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    $display("---\t\tFUNCTIONAL COVERAGE\t\t---");
    $display("WRITE COVERAGE = %0d\nREAD COVERAGE = %0d\n",write_cg.get_coverage(),read_cg.get_coverage());
  endfunction
endclass

