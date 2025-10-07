class fifo_wdriver extends uvm_driver#(fifo_sequence_item);
  virtual fifo_intf vif;
  `uvm_component_utils(fifo_wdriver)
  int count;

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
    repeat(2)@(vif.wdrv_cb);
    forever begin
      vif.wrstn <= 1;
      vif.winc <= 0; //Q) HAVE TO ASK  ABOUT IT
      seq_item_port.get_next_item(req);
      count++;
      drive();
      seq_item_port.item_done();
    end
  endtask

  task drive();
    //DRIVING THE WRITE SIGNALS
    vif.wrstn <= req.wrstn;
    vif.winc <= req.winc; //Q) HAVE TO ASK  ABOUT IT
    vif.wdata <= req.wdata;
    `uvm_info(get_name,"WRITTEN VALUES",UVM_MEDIUM)

    if(get_report_verbosity_level() >= UVM_MEDIUM)
    begin
      $display("---------%0d---------\nWRITE DRIVER SENT:\nWRSTN = %0b\nWINC = %0b\tWDATA = %0d",count,req.wrstn,req.winc,req.wdata);
    end

    repeat(1)@(vif.wdrv_cb);
    //repeat(1)@(vif.wdrv_cb);
  endtask
endclass

class fifo_rdriver extends uvm_driver#(fifo_sequence_item);
  virtual fifo_intf vif;
  `uvm_component_utils(fifo_rdriver)
  int count;

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
    repeat(2)@(vif.rdrv_cb);
    forever begin
      vif.rrstn <= 1;
      vif.rinc <= 0;
      seq_item_port.get_next_item(req);
      count++;
      drive();
      seq_item_port.item_done();
    end
  endtask

  task drive();
    //DRIVING THE READ SIGNALS
    vif.rrstn <= req.rrstn;
    vif.rinc <= req.rinc;
    `uvm_info(get_name,"WRITTEN VALUES",UVM_MEDIUM)
    if(get_report_verbosity_level() >= UVM_MEDIUM)
    begin
      $display("\t\t\t\t-------------%0d------------\n\t\t\t\tREAD DRIVER SENT:\n\t\t\t\tRRSTN = %0b\tRINC = %0b",count,req.rrstn,req.rinc);
    end

    repeat(1)@(vif.rdrv_cb);
  endtask
endclass
