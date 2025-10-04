`include "defines.svh"
`uvm_analysis_imp_decl(_w)
`uvm_analysis_imp_decl(_r)
class fifo_scoreboard extends uvm_scoreboard;
  fifo_sequence_item seq;
  `uvm_component_utils(fifo_scoreboard)

  uvm_analysis_imp_w#(fifo_scoreboard,fifo_sequence_item)w_item_collect_export;
  uvm_analysis_imp_r#(fifo_scoreboard,fifo_sequence_item)r_item_collect_export;

  function new(string name = "fifo_scoreboard",uvm_component parent = null);
    super.new(name,parent);
    w_item_collect_export = new("w_collect",this);
    r_item_collect_export = new("r_collect",this);
  endfunction

  int fifo[$];
  int wptr,rptr;
  bit full;

  virtual function void write_w(fifo_sequence_item wr);
    fifo_sequence_item a = wr;
    wptr = a.wrstn ? (a.wfull ? wptr : wptr + a.winc) : 0; //Q) when reset if increment is HIGH does it write the value/read the value?
    full = (fifo.size() == `DEPTH); //I) Depth of FIFO to be tested
    if(a.winc && full)
    begin
      if(wptr > fifo.size())
        fifo.push_back(a.wdata);
      else if(wptr < fifo.size())
        fifo.insert(wptr,a.wdata);
    end
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    repeat(2)@(vif.rdrv_cb);
    forever begin
      seq_item_port.get_next_item(req);
      drive();
      seq_item_port.item_done();
    end
  endtask

endclass
