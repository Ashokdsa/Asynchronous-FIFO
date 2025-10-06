`include "defines.svh"
class fifo_base_sequence extends uvm_sequence#(fifo_sequence_item);
  fifo_sequence_item seq;
  bit[`DATA-1:0]qu[$];
  `uvm_object_utils(fifo_base_sequence)

  function new(string name = "fifo_sequence");
    super.new(name);
  endfunction

  task body();
    `uvm_do_with(seq,{seq.winc || seq.rinc == 1; seq.wrstn && seq.rrstn == 1;})
  endtask
endclass

class fifo_write_sequence#(int val) extends fifo_base_sequence;
  `uvm_object_param_utils(fifo_write_sequence#(val))

  bit[`DATA-1:0] wval;
  int i;

  function new(string name = "fifo_write_sequence");
    super.new(name);
  endfunction

  task body();
    repeat(val)
    begin
      wval = wval + ((2**`DATA - 1)/(`DEPTH)); 
      `uvm_do_with(seq,
      {
        seq.winc == 1;
        seq.rinc == 0;
        seq.wdata == wval;
        seq.wrstn && seq.rrstn == 1;
      })
      i++;
      if(i == `DEPTH)
        `uvm_warning(get_type_name,"SHOULD TRIGGER FULL")
    end
  endtask
endclass

class fifo_read_sequence#(int val) extends fifo_base_sequence;
  `uvm_object_param_utils(fifo_read_sequence#(val))

  function new(string name = "fifo_read_sequence");
    super.new(name);
  endfunction

  task body();
    repeat(val)
    begin
      `uvm_do_with(seq,
      {
        seq.winc == 0;
        seq.rinc == 1;
        seq.wrstn && seq.rrstn == 1;
      })
    end
  endtask
endclass

class fifo_write_read_sequence#(int val) extends fifo_write_sequence#(val);
  `uvm_object_param_utils(fifo_write_read_sequence#(val))

  function new(string name = "fifo_write_read_sequence");
    super.new(name);
  endfunction

  task body();
    repeat(val)
    begin
      wval = wval + ((2**`DATA - 1)/(`DEPTH)); 
      //WRITE
      `uvm_do_with(seq,
      {
        seq.winc == 1;
        seq.rinc == 0;
        seq.wdata == wval;
        seq.wrstn && seq.rrstn == 1;
      })
      //READ
      `uvm_do_with(seq,
      {
        seq.winc == 0;
        seq.rinc == 1;
        seq.wrstn && seq.rrstn == 1;
      })
    end
  endtask
endclass

class fifo_no_sequence extends fifo_base_sequence;
  `uvm_object_utils(fifo_no_sequence)

  function new(string name = "fifo_no_sequence");
    super.new(name);
  endfunction

  task body();
    repeat(2) begin
      `uvm_do_with(seq,
      {
        seq.winc == 0;
        seq.rinc == 0;
        seq.wrstn && seq.rrstn == 1;
      })
    end
  endtask
endclass

class fifo_write_reset_sequence extends fifo_base_sequence;
  fifo_write_sequence#(4) seq1;
  fifo_read_sequence#(4) seq2;
  `uvm_object_utils(fifo_write_reset_sequence)

  function new(string name = "fifo_write_reset_sequence");
    super.new(name);
  endfunction

  task body();
    //WRITE 4 TIMES
    `uvm_do(seq1)

    //WINC = 0
    `uvm_do_with(seq,
    {
      seq.winc == 0;
      seq.wrstn == 0;
    })

    //WINC = 1
    `uvm_do_with(seq,
    {
      seq.winc == 1;
      seq.wrstn == 0;
    })

    //READ 4 TIMES
    `uvm_do(seq2)
  endtask
endclass

class fifo_read_reset_sequence extends fifo_base_sequence;
  fifo_write_sequence#(4) seq1;
  fifo_read_sequence#(2) seq2;
  `uvm_object_utils(fifo_read_reset_sequence)

  function new(string name = "fifo_read_reset_sequence");
    super.new(name);
  endfunction

  task body();
    //WRITE 4 TIMES
    `uvm_do(seq1)

    //READ 2 TIMES
    `uvm_do(seq2)

    //WINC = 0
    `uvm_do_with(seq,
    {
      seq.rinc == 0;
      seq.rrstn == 0;
    })

    //WINC = 1
    `uvm_do_with(seq,
    {
      seq.rinc == 1;
      seq.rrstn == 0;
    })

    //READ 2 TIMES
    `uvm_do(seq2)
  endtask
endclass

class fifo_regress_sequence extends fifo_base_sequence;
  fifo_read_sequence#(2) in_r_seq;
  fifo_write_sequence#(`DEPTH + 2) w_seq;
  fifo_read_sequence#(`DEPTH + 2) r_seq;
  fifo_write_read_sequence#(`DEPTH + 4) wr_seq;
  fifo_read_reset_sequence seq_r;
  fifo_write_reset_sequence seq_w;
  fifo_no_sequence n_seq;

  `uvm_object_utils(fifo_regress_sequence)

  function new(string name = "fifo_regress_sequence");
    super.new(name);
  endfunction

  task body();
  endtask
endclass

class virtual_sequence#(type T = fifo_base_sequence) extends fifo_base_sequence;
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

    fork
      begin
        seq_1.start(env_s.vseqr.seqr_1);
        `uvm_info(get_type_name,"SEQUENCER 1 HAS BEGUN",UVM_LOW)
      end
      begin
        seq_2.start(env_s.vseqr.seqr_2);
        `uvm_info(get_type_name,"SEQUENCER 2 HAS BEGUN",UVM_LOW)
      end
    join
  endtask
endclass
