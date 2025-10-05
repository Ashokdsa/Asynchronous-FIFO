class fifo_test extends uvm_test;
  fifo_environment env;
  virtual_sequence#(fifo_base_sequence) vseq;

  function new(string name = "fifo_test",uvm_component parent = null);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = fifo_environment::type_id::create("fifo_environment",this);
  endfunction

  function void end_of_elaboration();
    uvm_top.print_topology();
  endfunction

  task run_phase(uvm_phase phase);
    uvm_objection phase_done = phase.get_objection();
    super.run_phase(phase);
    phase.raise_objection(this,"SEQUENCE STARTED");
      vseq = virtual_sequence::type_id::create("virtual_sequence");
      vseq.start(env.vseqr);
    phase.drop_objection(this,"SEQUENCE ENDED");
    phase_done.set_drain_time(this,20);
  endtask
endclass
