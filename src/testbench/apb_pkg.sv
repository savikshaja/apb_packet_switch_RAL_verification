package apb_pkg;

	import uvm_pkg::*;
	`include "uvm_macros.svh"

	// APB transaction, sequencer, driver, monitor, agent
	`include "apb_transaction.sv"
	`include "apb_sequencer.sv"
	`include "apb_driver.sv"
	`include "apb_monitor.sv"
	`include "apb_agent.sv"

	// Register classes
	`include "apb_registers/device_id.sv"
	`include "apb_registers/version.sv"
	`include "apb_registers/switch_status.sv"
	`include "apb_registers/port_status.sv"
	`include "apb_registers/gen_status.sv"
	`include "apb_registers/stat_rx.sv"
	`include "apb_registers/stat_tx.sv"
	`include "apb_registers/stat_drop.sv"
	`include "apb_registers/switch_ctrl.sv"
	`include "apb_registers/port_enable.sv"
	`include "apb_registers/fwd_enable.sv"
	`include "apb_registers/gen_ctrl.sv"
	`include "apb_registers/gen_pkt_cfg.sv"
	`include "apb_registers/gen_interval.sv"
	`include "apb_registers/gen_count.sv"
	`include "apb_registers/irq_status.sv"
	`include "apb_registers/irq_enable.sv"
	`include "apb_registers/irq_force.sv"
	`include "apb_registers/err_status.sv"
	`include "apb_registers/err_enable.sv"
	`include "apb_registers/err_inject.sv"
	`include "apb_registers/err_count.sv"
	`include "apb_registers/err_info.sv"
	`include "apb_registers/lock.sv"
	`include "apb_registers/soft_reset.sv"

	// Register block
	`include "reg_block.sv"

	// RAL adapter
	`include "apb_adapter.sv"

	// Sequences (base first)
	//`include "apb_base_seq.sv"
	//`include "gen_count_seq.sv"
	`include "top_reg_seq.sv"

	// Coverage, environment and test
	`include "apb_subscriber.sv"
	`include "apb_env.sv"
	`include "test.sv"

endpackage : apb_pkg
