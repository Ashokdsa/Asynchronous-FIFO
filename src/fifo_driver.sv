class fifo_wdriver extends uvm_driver#(fifo_sequence_item);
  virtual fifo_intf vif;
  `uvm_component_utils(fifo_wdriver)

  function new(string name = "fifo_wdriver",uvm_component parent = null);
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
    forever begin
      seq_item_port.get_next_item(req);
      drive();
      seq_item_port.item_done();
    end
  endtask

  task drive();
    //DRIVING THE WRITE SIGNALS
    vif.wrstn <= req.wrstn;
    if(req.wrstn)
    begin
      vif.winc <= (vif.wfull) ? 0 : req.winc; //Q) HAVE TO ASK  ABOUT IT
      if(vif.wfull)
        `uvm_fatal(get_name,"FIFO IS FULL")
      vif.wdata <= req.wdata;
    end
    else
    begin
      vif.winc <= req.winc;
      vif.wdata <= req.wdata;
    end
    if(get_verbosity_level() >= UVM_MEDIUM)
    begin
      $display("WRITE DRIVER SENT:\nWRSTN = %0b\nWINC = %0b\tWDATA = %0d",req.wrstn,req.winc,req.wdata);
    end
    repeat(2)@(vif.wdrv_cb);
  endtask
endclass

class fifo_rdriver extends uvm_driver#(fifo_sequence_item);
  virtual fifo_intf vif;
  `uvm_component_utils(fifo_rdriver)

  function new(string name = "fifo_rdriver",uvm_component parent = null);
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
    forever begin
      seq_item_port.get_next_item(req);
      drive();
      seq_item_port.item_done();
    end
  endtask

  task drive();
    //DRIVING THE WRITE SIGNALS
    vif.rrstn <= req.wrstn;
    if(req.wrstn)
    begin
      vif.rinc <= (vif.rempty) ? 0 : req.rinc;
    end
    else
    begin
      vif.rinc <= req.rinc;
    end
    if(get_verbosity_level() >= UVM_MEDIUM)
    begin
      $display("READ DRIVER SENT:\nRRSTN = %0b\tRINC = %0b",req.rrstn,req.rinc);
    end
    repeat(2)@(vif.rdrv_cb);
  endtask
endclass
