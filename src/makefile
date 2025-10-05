QUESTA := /home/share/questa.csh
SHELL := /bin/csh
TEST ?= fifo_regress_test
V ?= UVM_DEBUG
WCLK ?= 100
RCLK ?= 100

.ONESHELL:	
all:
	source $(QUESTA)
	make clean
	make compile
	make simulate
	vcover report -html fifo_coverage.ucdb -htmldir covReport -details

clean:
	rm -rf work/ transcript vsim.wlf fifo_wave.vcd
	rm -rf covReport fifo_coverage.ucdb
	rm fifo.log simulation.log
	rm fifo_coverage.ucdb
	clear
	clear
	clear

compile:
	@echo "\t\t\t\t...............................COMPILING CODE WITH WCLK = $(WCLK)MHz RCLK = $(RCLK)MHz..............................."
	source $(QUESTA)
	vlog -sv +acc +cover +fcover +define+WCLK=$(WCLK) +define+RCLK=$(RCLK) -l fifo.log fifo_top.sv 

wave:
	make compile
	@echo "\t\t\t\t\t...............GENERATING WAVEFORM FOR TEST = $(TEST)..............."
	vsim -novopt work.fifo_top +UVM_TESTNAME=$(TEST) +UVM_VERBOSITY=$(V)

simulate:
	@echo "\t\t\t\t...........................SIMULATING TEST = $(TEST) WITH VERBOSITY = $(V)..........................."
	vsim -vopt work.fifo_top -voptargs=+acc=npr -assertdebug -l simulation.log -coverage -c -do "coverage save -onexit -assert -directive -cvg -codeAll fifo_coverage.ucdb; run -all; exit" +UVM_TESTNAME=$(TEST) +UVM_VERBOSITY=$(V)

view:
	firefox ./covReport/index.html
