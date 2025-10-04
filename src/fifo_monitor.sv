class fifo_wmonitor extends uvm_monitor;
  virtual fifo_intf vif;
  fifo_sequence_item seq;
  uvm_analysis_port#(seq)item_collected_port;
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
    //INSERT DELAYS
    repeat(1)@(vif.wmon_cb); //STARTS ONE CLOCK AFTER DRIVE
    forever begin
      seq = fifo_sequence_item::type_id::create("seq_item");
      #0;
      seq.wrstn = vif.wrstn;
      seq.winc = vif.winc;
      seq.wdata = vif.wdata;
      seq.wfull = vif.wfull;
      item_collected_port.write(seq);
      if(get_verbosity_level() >= UVM_MEDIUM)
      begin
        $display("WRITE MONITOR READ:\nWRSTN = %0b\nWINC = %0b\tWDATA = %0d\tWFULL = %0b",seq.wrstn,seq.winc,seq.wdata,seq.wfull);
      end
      repeat(2)@(vif.wmon_cb); //SAME DELAY AS DRIVER
    end
  endtask
endclass
