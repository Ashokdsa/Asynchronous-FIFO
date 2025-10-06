class fifo_test extends uvm_test;
  `uvm_component_utils(fifo_test)
  fifo_environment env;
  virtual_sequence#(fifo_base_sequence) vseq;

  function new(string name = "fifo_test",uvm_component parent = null);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = fifo_environment::type_id::create("env",this);
  endfunction

  function void end_of_elaboration();
    uvm_top.print_topology();
  endfunction

  task run_phase(uvm_phase phase);
    uvm_objection phase_done = phase.get_objection();
    super.run_phase(phase);
    phase.raise_objection(this);
      vseq = virtual_sequence#(fifo_base_sequence)::type_id::create("virtual_sequence");
      vseq.start(env.vseqr);
    phase.drop_objection(this);
    phase_done.set_drain_time(this,20);
  endtask
endclass

class fifo_regress_test extends uvm_test;
  fifo_environment env;
  virtual_sequence#(fifo_regress_sequence) vseq;

  `uvm_component_utils(fifo_regress_test)

  function new(string name = "fifo_regress_test",uvm_component parent = null);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = fifo_environment::type_id::create("env",this);
  endfunction

  function void end_of_elaboration();
    uvm_top.print_topology();
  endfunction

  task run_phase(uvm_phase phase);
    uvm_objection phase_done = phase.get_objection();
    super.run_phase(phase);
    phase.raise_objection(this);
      vseq = virtual_sequence#(fifo_regress_sequence)::type_id::create("virtual_sequence");
      vseq.start(env.vseqr);
    phase.drop_objection(this);
    phase_done.set_drain_time(this,20);
  endtask
endclass
