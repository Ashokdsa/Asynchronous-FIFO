class fifo_base_sequence extends uvm_sequence#(fifo_sequence_item);
  fifo_sequence_item seq;
  int qu[$];
  `uvm_object_utils(fifo_base_sequence)

  function new(string name = "fifo_sequence");
    super.new(name);
  endfunction

  task body();
    `uvm_do(seq)
  endtask
endclass

class virtual_sequence#(type T = fifo_base_sequence) extends uvm_sequence#(fifo_sequence_item);
  fifo_base_sequence seq_1;
  fifo_base_sequence seq_2;
  `uvm_object_param_utils(virtual_sequence#(T))

  function new(string name = "virtual_sequence");
    super.new(name);
    fifo_base_sequence::type_id::set_type_override(T::get_type());
    `uvm_info(get_type_name,$sformatf("RUNNING %0s",fifo_base_sequence::get_type_name()),UVM_LOW)
  endfunction

  task body();
    fifo_environment env_s;
    `uvm_info(get_type_name,"VIRTUAL SEQUENCE BEGUN",UVM_LOW)
    seq_1 = fifo_base_sequence::type_id::create("seq_1");
    seq_2 = fifo_base_sequence::type_id::create("seq_2");

    if(!$cast(env_s,uvm_top.find("uvm_test_top.env")))
      `uvm_error(get_name(),"Environment is NOT Created")

    seq_1.start(env_s.vseqr.seqr_1);
    `uvm_info(get_type_name,"SEQUENCER 1 HAS BEGUN",UVM_LOW)
    seq_2.start(env_s.vseqr.seqr_2);
    `uvm_info(get_type_name,"SEQUENCER 2 HAS BEGUN",UVM_LOW)
  endtask
endclass
