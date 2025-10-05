class fifo_wmonitor extends uvm_monitor;
  virtual fifo_intf vif;
  fifo_sequence_item seq;
  uvm_analysis_port#(fifo_sequence_item)item_collected_port;
  `uvm_component_utils(fifo_wmonitor)

  function new(string name = "fifo_wmonitor",uvm_component parent = null);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual fifo_intf)::get(this," ","vif",vif))
      `uvm_fatal(get_name,"VIF NOT SET")
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    repeat(2)@(vif.wmon_cb);
    repeat(1)@(vif.wmon_cb); //STARTS ONE CLOCK AFTER DRIVE
    forever begin
      seq = fifo_sequence_item::type_id::create("seq_item");
      #0;
      seq.wrstn = vif.wrstn;
      seq.winc = vif.winc;
      seq.wdata = vif.wdata;
      seq.wfull = vif.wfull;
      item_collected_port.write(seq);
      if(get_report_verbosity_level() >= UVM_MEDIUM)
      begin
        $display("WRITE MONITOR READ:\nWRSTN = %0b\nWINC = %0b\tWDATA = %0d\tWFULL = %0b",seq.wrstn,seq.winc,seq.wdata,seq.wfull);
      end
      repeat(2)@(vif.wmon_cb); //SAME DELAY AS DRIVER
    end
  endtask
endclass

class fifo_rmonitor extends uvm_monitor;
  virtual fifo_intf vif;
  fifo_sequence_item seq;
  uvm_analysis_port#(fifo_sequence_item)item_collected_port;
  `uvm_component_utils(fifo_rmonitor)

  function new(string name = "fifo_rmonitor",uvm_component parent = null);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual fifo_intf)::get(this," ","vif",vif))
      `uvm_fatal(get_name,"VIF NOT SET")
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    repeat(2)@(vif.rmon_cb);
    repeat(1)@(vif.rmon_cb); //STARTS ONE CLOCK AFTER DRIVE
    forever begin
      seq = fifo_sequence_item::type_id::create("seq_item");
      #0;
      seq.rrstn = vif.rrstn;
      seq.rinc = vif.rinc;
      seq.rdata = vif.rdata;
      seq.rempty = vif.rempty;
      item_collected_port.write(seq);
      if(get_report_verbosity_level() >= UVM_MEDIUM)
      begin
        $display("READ MONITOR READ:\nRRSTN = %0b\nRINC = %0b\nRDATA = %0d\tREMPTY = %0b",seq.rrstn,seq.rinc,seq.rdata,seq.rempty);
      end
      repeat(2)@(vif.rmon_cb); //SAME DELAY AS DRIVER
    end
  endtask
endclass
