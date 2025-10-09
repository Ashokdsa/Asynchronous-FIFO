`include "defines.svh"
class fifo_write_test extends uvm_test;
  `uvm_component_utils(fifo_write_test)
  fifo_environment env;
  virtual_sequence#(fifo_write_sequence#(`DEPTH + 2)) vseq;

  function new(string name = "fifo_write_test",uvm_component parent = null);
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
      vseq = virtual_sequence#(fifo_write_sequence#(`DEPTH + 2))::type_id::create("virtual_sequence");
      vseq.start(env.vseqr);
    phase.drop_objection(this);
    phase_done.set_drain_time(this,120);
  endtask
endclass

class fifo_read_test extends uvm_test;
  `uvm_component_utils(fifo_read_test)
  fifo_environment env;
  virtual_sequence#(fifo_read_sequence#(5)) vseq;

  function new(string name = "fifo_read_test",uvm_component parent = null);
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
      vseq = virtual_sequence#(fifo_read_sequence#(5))::type_id::create("virtual_sequence");
      vseq.start(env.vseqr);
    phase.drop_objection(this);
    phase_done.set_drain_time(this,120);
  endtask
endclass

class fifo_write_read_test extends uvm_test; //ONE IDLE STATE BETWEEN EACH SENDER AND RECIEVER
  `uvm_component_utils(fifo_write_read_test)
  fifo_environment env;
  virtual_sequence#(fifo_write_read_sequence#(5)) vseq;

  function new(string name = "fifo_write_read_test",uvm_component parent = null);
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
      vseq = virtual_sequence#(fifo_write_read_sequence#(5))::type_id::create("virtual_sequence");
      vseq.start(env.vseqr);
    phase.drop_objection(this);
    phase_done.set_drain_time(this,120);
  endtask
endclass

class fifo_writeandread_test extends uvm_test;
  `uvm_component_utils(fifo_writeandread_test)
  fifo_environment env;
  virtual_sequence#(fifo_writeandread_sequence#(30)) vseq;

  function new(string name = "fifo_writeandread_test",uvm_component parent = null);
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
      vseq = virtual_sequence#(fifo_writeandread_sequence#(30))::type_id::create("virtual_sequence");
      vseq.start(env.vseqr);
    phase.drop_objection(this);
    phase_done.set_drain_time(this,120);
  endtask
endclass

class fifo_no_test extends uvm_test;
  `uvm_component_utils(fifo_no_test)
  fifo_environment env;
  virtual_sequence#(fifo_no_sequence#(4)) vseq;

  function new(string name = "fifo_no_test",uvm_component parent = null);
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
      vseq = virtual_sequence#(fifo_no_sequence#(4))::type_id::create("virtual_sequence");
      vseq.start(env.vseqr);
    phase.drop_objection(this);
    phase_done.set_drain_time(this,120);
  endtask
endclass

class fifo_write_reset_test extends uvm_test;
  `uvm_component_utils(fifo_write_reset_test)
  fifo_environment env;
  virtual_sequence#(fifo_write_reset_sequence) vseq;

  function new(string name = "fifo_write_reset_test",uvm_component parent = null);
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
      vseq = virtual_sequence#(fifo_write_reset_sequence)::type_id::create("virtual_sequence");
      vseq.start(env.vseqr);
    phase.drop_objection(this);
    phase_done.set_drain_time(this,120);
  endtask
endclass

class fifo_read_reset_test extends uvm_test;
  `uvm_component_utils(fifo_read_reset_test)
  fifo_environment env;
  virtual_sequence#(fifo_read_reset_sequence) vseq;

  function new(string name = "fifo_read_reset_test",uvm_component parent = null);
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
      vseq = virtual_sequence#(fifo_read_reset_sequence)::type_id::create("virtual_sequence");
      vseq.start(env.vseqr);
    phase.drop_objection(this);
    phase_done.set_drain_time(this,120);
  endtask
endclass

class fifo_write_reset_full_test extends uvm_test;
  `uvm_component_utils(fifo_write_reset_full_test)
  fifo_environment env;
  virtual_sequence#(fifo_write_reset_full_sequence) vseq;

  function new(string name = "fifo_write_reset_full_test",uvm_component parent = null);
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
      vseq = virtual_sequence#(fifo_write_reset_full_sequence)::type_id::create("virtual_sequence");
      vseq.start(env.vseqr);
    phase.drop_objection(this);
    phase_done.set_drain_time(this,120);
  endtask
endclass

class fifo_regress_test extends uvm_test;
  fifo_environment env;
  virtual_regress_sequence vseq;

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
      vseq = virtual_regress_sequence::type_id::create("virtual_sequence");
      vseq.start(env.vseqr);
    phase.drop_objection(this);
    phase_done.set_drain_time(this,120);
  endtask
endclass
