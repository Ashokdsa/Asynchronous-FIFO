`include "defines.svh"
`uvm_analysis_imp_decl(_w)
`uvm_analysis_imp_decl(_r)
class fifo_scoreboard extends uvm_scoreboard;
  fifo_sequence_item seq;
  `uvm_component_utils(fifo_scoreboard)

  uvm_analysis_imp_w#(fifo_scoreboard,fifo_sequence_item)w_item_collect_export;
  uvm_analysis_imp_r#(fifo_scoreboard,fifo_sequence_item)r_item_collect_export;

  int MATCH,MISMATCH;

  function new(string name = "fifo_scoreboard",uvm_component parent = null);
    super.new(name,parent);
    w_item_collect_export = new("w_collect",this);
    r_item_collect_export = new("r_collect",this);
  endfunction

  int fifo[$];
  int wptr,rptr;
  bit full;
  int full_i;
  bit empti = 1;
  int empty_i;
  int read_val;

//GOT TO CHANGE THE REFERENCE
  virtual function void write_w(fifo_sequence_item wr);
    fifo_sequence_item a = wr;
    `uvm_info(get_name,"RECIEVED THE WRITE OUTPUT",UVM_MEDIUM)
    wptr = a.wrstn ? (full ? wptr : wptr + a.winc) : 0; //Q) when reset if increment is HIGH does it write the value/read the value?
    full = (fifo.size() == `DEPTH); //I) Depth of FIFO to be tested
    if(a.winc && !full)
    begin
      if(wptr > fifo.size())
        fifo.push_back(a.wdata);
      else if(wptr < fifo.size())
        fifo.insert(wptr,a.wdata);
    end
    if(full != a.wfull)
    begin
      full_i++;
      `uvm_warning(get_name,$sformatf("FULL SIGNAL IS INCORRECT %0d TIMES",full_i))
    end
  endfunction

//think of the solution soon
  virtual function void write_r(fifo_sequence_item rd);
    fifo_sequence_item b = rd;
    `uvm_info(get_name,"RECIEVED THE READ OUTPUT",UVM_MEDIUM)
    rptr = b.rrstn ? (empti ? rptr : rptr + b.rinc) : 0; //Q) when reset if increment is HIGH does it write the value/read the value?
    read_val = fifo[rptr];
    if(b.rinc && !empti) //Q) WHAT IF I WRITE TWICE, READ ONCE AND THEN ASSERT RRESET,WHAT WILL IT READ NEXT
    begin
      if(rptr == wptr)
      begin
        read_val = fifo.pop_front();
        wptr = 0;
        rptr = 0;
      end
      else if(rptr > wptr)
      begin
        read_val = fifo[rptr];
        fifo.delete(rptr);
      end
    end
    empti = (fifo.size() == 0); //I) Depth of FIFO to be tested
    if(empti)
    begin
      wptr = 0;
      rptr = 0;
    end
    if(empti != b.rempty)
    begin
      empty_i++;
      `uvm_warning(get_name,$sformatf("EMPTY SIGNAL IS INCORRECT %0d TIMES",empty_i))
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
