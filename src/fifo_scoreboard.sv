`include "defines.svh"
`uvm_analysis_imp_decl(_w)
`uvm_analysis_imp_decl(_r)
class fifo_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(fifo_scoreboard)

  fifo_sequence_item a,b;

  uvm_analysis_imp_w#(fifo_scoreboard,fifo_sequence_item)w_item_collect_export;
  uvm_analysis_imp_r#(fifo_scoreboard,fifo_sequence_item)r_item_collect_export;

  int MATCH,MISMATCH;

  function new(string name = "fifo_scoreboard",uvm_component parent = null);
    super.new(name,parent);
    w_item_collect_export = new("w_collect",this);
    r_item_collect_export = new("r_collect",this);
  endfunction

  logic[`DATA-1:0] fifo[$];
  logic[($clog2(`DEPTH)) : 0] wptr,rptr;
  bit full;
  int full_i;
  bit empti = 1;
  int empty_i;
  logic[`DATA-1:0] read_val;
//Q) DIFFERENT TIME OF START OF CLOCK
  virtual function void write_w(fifo_sequence_item wr);
    a = wr;
    `uvm_info(get_name,"RECIEVED THE WRITE OUTPUT",UVM_MEDIUM)
    wptr = a.wrstn ? (full ? wptr : wptr + a.winc) : 0; //Q) when reset if increment is HIGH does it write the value/read the value?
    if(a.winc && !full && a.wrstn)
    begin
      if(wptr > fifo.size())
        fifo.push_back(a.wdata);
      else if(wptr < fifo.size())
        fifo.insert(wptr[($clog2(`DEPTH)-1):0],a.wdata);
      `uvm_info(get_name,$sformatf("WROTE %0d",a.wdata),UVM_DEBUG)
    end
    else if(!a.wrstn)
    begin
      while(fifo.size())
        void'(fifo.pop_front());
      rptr = 0;
    end
    full = (fifo.size() == `DEPTH); //I) Depth of FIFO to be tested
    if(full !== a.wfull)
    begin
      full_i++;
      `uvm_warning(get_name,$sformatf("FULL SIGNAL IS INCORRECT %0d TIMES",full_i))
    end
  endfunction

  fifo_sequence_item rqu[$];

  virtual function void write_r(fifo_sequence_item rd);
    fifo_sequence_item read = rd;
    `uvm_info(get_name,"RECIEVED THE READ OUTPUT",UVM_MEDIUM)
    rqu.push_back(read);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      `uvm_info(get_name,"ENTERED SCB",UVM_DEBUG)
      wait(rqu.size());
      b = rqu.pop_front();
      rptr = b.rrstn ? (empti ? rptr : rptr + b.rinc) : 0; //Q) when reset if increment is HIGH does it write the value/read the value?
      empti = (fifo.size() == 0); //I) Depth of FIFO to be tested
      if(b.rinc && !empti && b.rrstn)
      begin
        read_val = fifo.pop_front(); //I) NOT CHANGING EVEN IF RESET
        `uvm_info(get_name,$sformatf("READ %0d",read_val),UVM_DEBUG)
      end
      if(empti !== b.rempty)
      begin
        empty_i++;
        `uvm_warning(get_name,$sformatf("EMPTY SIGNAL IS INCORRECT %0d TIMES",empty_i))
      end
      //OUTPUT COMPARISON
      if(read_val === b.rdata)
      begin
        `uvm_info(get_name,$sformatf("PROPER READ OUTPUT\nEXPECTED = %0d RECIEVED = %0d",read_val,b.rdata),UVM_LOW)
        MATCH++;
      end
      else
      begin
        `uvm_error(get_name,$sformatf("\t\t\t\tIMPROPER READ OUTPUT\nEXPECTED = %0d RECIEVED = %0d",read_val,b.rdata),UVM_LOW)
        MISMATCH++;
      end
    end
  endtask
endclass
