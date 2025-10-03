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
  @(vif.wmon_cb;b
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
      vif.winc <= (vif.wfull) ? 0 : req.winc;
      vif.wdata <= req.wdata;
    end
    else
    begin
      vif.winc <= req.winc;
      vif.wdata <= req.wdata;
    end
    repeat(2)@(vif.wdrv_cb);
  endtask
endclass
