# Asynchronous FIFO
This Repository contains the verification tesbench and plans for testing of Asynchronous FIFO using SV(UVM)

<img width="5349" height="3865" alt="2_agent" src="https://github.com/user-attachments/assets/76e40663-6fca-4d5a-ac00-95cf02d10889" />

---
## Overview
This repository contains a simple UVM testbench for verifying the Asynchronous FIFO. The verification environment includes UVM components such as environment, driver, monitor, scoreboard, and test sequences. A Makefile is provided to compile, simulate, and clean the verification runs.

## Testbench Components
- **`fifo_top.sv`**: Instantiates Asycnchronus FIFO and ties together the testbench.
- **`fifo_test.sv`**: Instantiates and initializes the testbench components.
- **`fifo_environment.sv`**: UVM environment coordinating verification agents.
- **`fifo_read_driver`**: Drives Read Inputs for DUT interface.
- **`fifo_write_driver`**: Drives Write Inputs for DUT interface.
- **`fifo_sequencer.sv`**: Contains a FIFO and handles the syncronzation between `fifo_write_driver` and `fifo_sequence`, and a sequencer for `fifo_read_driver` and `fifo_sequence`.
- **`fifo_write_monitor.sv`**: Used to capture **WRITE** inputs and outputs and send it to `fifo_scoreboard` and `fifo_subscriber` transactions.
- **`fifo_read_monitor.sv`**: Used to capture **READ** inputs and outputs and send it to `fifo_scoreboard` and `fifo_subscriber` transactions.
- **`fifo_write_agent.sv`**: Instantiates `fifo_write_driver`, `fifo_write_sequencer` and `fifo_write_monitor`, and connects `fifo_write_sequencer` and `fifo_write_driver`.
- **`fifo_read_agent.sv`**: Instantiates `fifo_read_driver`, `fifo_read_sequencer` and `fifo_read_monitor`, and connects `fifo_read_sequencer` and `fifo_read_driver`.
- **`fifo_scoreboard.sv`**: Checks correctness against expected behavior.
- **`fifo_sequence.sv`**: Test scenarios driving the driver.
- **`fifo_sequence_item.sv`**: Used to communicate between the testbench components.
- **`fifo_interface.sv`**: Bundles together a set of signals and associated behaviors to simplify the connection and communication between modules.

## Repository Structure
├── docs # Test Plans and documentation \
├── src # Testbench source files (UVM components) \
│   ├── defines.svh  \
│   ├── fifo_agent.sv  \
│   ├── fifo_assertion.sv \
│   ├── fifo_driver.sv  \
│   ├── fifo_environment.sv           
│   ├── fifo_interface.sv \
│   ├── fifo_monitor.sv        
│   ├── fifo_pkg.svh       
│   ├── fifo_scoreboard.sv \
│   ├── fifo_sequence.sv    
│   ├── fifo_sequence_item.sv         
│   ├── fifo_sequencer.sv \
│   ├── fifo_subscriber.sv     
│   ├── fifo_subscriber.sv \
│   ├── fifo_test.sv  \
│   ├── fifo_top.sv  \
│   └── makefile \
└── README.md # Current File

## Running the Testbench
### Pre-Requisites
A **SystemVerilog simulator** that supports **UVM**, such as **QuestaSim**, **Cadence Xcelium**, or **Synopsys VCS**. \
\
*The makefile present in the **src/** contains only the execution commands for QuestaSim*

## Makefile Usage
The **Makefile** automates the compilation, and simulation of the **UVM** testbench. Which can be accessed only in the **src/** folder
1. To run the simulation with **UVM_MEDIUM** Verbosity and test **fifo_writeandread_test**.
  ```
  make
  ```
  ***By Default Write Clock = 100MHz Read Clock = 50MHz*** \
  \
2. To run the simulation with **SPECIFIC** Verbosity, with **other test cases** along with with **SPECIFIC** Write and Read Clock **(in MHz)**.
  ```
  make TEST=<test_name> V=<required_verbosity> WCLK=<Write_Clock_in_MHz> RCLK=<Read_Clock_in_MHz>
  ```
  Example:
  `make TEST=fifo_writeandread_test V=UVM_MEDIUM WCLK=100 RCLK=50` \
  \
3. To **clean up** log files, waveforms and cover report generated
  ```
  make clean
  ```
To simulate it **manually**
  ```
  source <Questa_location>
  vlog -sv +acc +cover +fcover -l fifo.log fifo_top.sv
  vsim -novopt work.fifo_top
  ```

Modify the Makefile as necessary for your simulator setup.
