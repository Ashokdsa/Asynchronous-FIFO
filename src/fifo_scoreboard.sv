`include "defines.svh"
`uvm_analysis_imp_decl(_w)
`uvm_analysis_imp_decl(_r)
class fifo_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(fifo_scoreboard)

  fifo_sequence_item a,b;

  uvm_analysis_imp_w#(fifo_sequence_item,fifo_scoreboard)w_item_collect_export;
  uvm_analysis_imp_r#(fifo_sequence_item,fifo_scoreboard)r_item_collect_export;

  int MATCH,MISMATCH;

  function new(string name = "fifo_scoreboard",uvm_component parent = null);
    super.new(name,parent);
    w_item_collect_export = new("w_scb_collect",this);
    r_item_collect_export = new("r_scb_collect",this);
  endfunction

  logic[`DATA-1:0] fifo[$:`DEPTH];
  bit[($clog2(`DEPTH)) : 0] wptr,rptr;
  bit full;
  int full_i;
  bit empti;
  int empty_i;
  logic[`DATA-1:0] read_val;

  //Q) DIFFERENT TIME OF START OF CLOCK

  //WFULL IS NOT PROPERLY VERIFIED AS IT IS READ TOO EARLY
  virtual function void write_w(fifo_sequence_item wr);
    a = wr;
    `uvm_info(get_name,$sformatf("RECIEVED THE WRITE OUTPUT FULL = %0d",full),UVM_DEBUG)
    if(a.winc && !full && a.wrstn)
    begin
      if(wptr == fifo.size() && fifo.size() < `DEPTH)
        fifo.push_back(a.wdata);
      else
      begin
        fifo[wptr[($clog2(`DEPTH) - 1):0]] = a.wdata;
      end
    end
    $display("FIFO:%0p\nwptr = %5b rptr = %5b",fifo,wptr,rptr);
    wptr = a.wrstn ? (full ? wptr : wptr + a.winc) : 0; //Q) when reset if increment is HIGH does it write the value/read the value?
    full = ({!wptr[$clog2(`DEPTH)],wptr[$clog2(`DEPTH)-1:0]} == rptr) && a.wrstn; //I) Depth of FIFO to be tested
    `uvm_info(get_name,$sformatf("wptr = %5b COND1 = %5b COND2 = %5b",wptr,{~wptr[$clog2(`DEPTH)-1],wptr[$clog2(`DEPTH)-2:0]},rptr),UVM_DEBUG)
    if(full !== a.wfull)
    begin
      full_i++;
      `uvm_warning(get_name,"FULL SIGNAL IS INCORRECT")
    end
  endfunction

  fifo_sequence_item rqu[$];

  virtual function void write_r(fifo_sequence_item rd);
    fifo_sequence_item read = rd;
    `uvm_info(get_name,"RECIEVED THE READ OUTPUT",UVM_DEBUG)
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
      empti = (fifo.size() == 0) || (rptr == wptr) || !b.rrstn; //I) Depth of FIFO to be tested
      `uvm_info(get_name,$sformatf("RECIEVED THE READ OUTPUT EMPTY = %0d",empti),UVM_DEBUG)
      rptr = b.rrstn ? (empti ? rptr : rptr + b.rinc) : 0; //Q) when reset if increment is HIGH does it write the value/read the value?
      `uvm_info(get_name,$sformatf("rptr = %4d EMPTY = %0b RINC = %0b FIFO[rptr] = %0d",rptr[$clog2(`DEPTH)-1:0],empti,b.rinc,fifo[rptr[$clog2(`DEPTH)-1:0]]),UVM_DEBUG)
      if(rptr == 5)
        $display("%0p",fifo);
      read_val = fifo[rptr[$clog2(`DEPTH)-1:0]];
      if(empti !== b.rempty)
      begin
        empty_i++;
        `uvm_warning(get_name,"EMPTY SIGNAL IS INCORRECT")
      end
      //OUTPUT COMPARISON
      $display("\n||-----------------------------------------------------------------------------------------------------------------------||");
      if(read_val === b.rdata)
      begin
        `uvm_info(get_name,$sformatf("READ OUTPUT MATCHED: EXPECTED = %0d RECIEVED = %0d",read_val,b.rdata),UVM_LOW)
        MATCH++;
      end
      else
      begin
        `uvm_error(get_name,$sformatf("READ OUTPUT MISMATCH: EXPECTED = %0d RECIEVED = %0d",read_val,b.rdata))
        MISMATCH++;
      end
      $display("||-----------------------------------------------------------------------------------------------------------------------||\n");
    end
  endtask

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    $display("------------------------------------------FINAL PERCENTAGES------------------------------------------");
    `uvm_info(get_name,$sformatf("MATCHES = %0d MISMATCH = %0d PERCENTAGE = %0f",MATCH,MISMATCH,(real'(MATCH)/(real'(MATCH)+real'(MISMATCH)))*100),UVM_LOW)
    `uvm_warning(get_name,$sformatf("FULL SIGNAL WAS INCORRECT %0d TIMES",full_i))
    `uvm_warning(get_name,$sformatf("EMPTY SIGNAL WAS INCORRECT %0d TIMES",empty_i))
    $display("-----------------------------------------------------------------------------------------------------");
  endfunction
endclass
