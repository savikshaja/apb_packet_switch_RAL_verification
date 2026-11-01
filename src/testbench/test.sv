class apb_base_test extends uvm_test;

	apb_env env;

	`uvm_component_utils(apb_base_test)

	function new(string name = "apb_base_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		env = apb_env::type_id::create("env", this);
	endfunction : build_phase

	function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		uvm_top.print_topology();
	endfunction : end_of_elaboration_phase

endclass : apb_base_test


class ro_test extends apb_base_test;

	ro_seq seq;
	`uvm_component_utils(ro_test)

	function new(string name = "ro_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq = ro_seq::type_id::create("seq", this);
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		phase.phase_done.set_drain_time(this, 100ns);
		phase.raise_objection(this, "Objection Raised");
		seq.regmodel = env.regmodel;
		seq.start(env.agent_inst.seqr);
		$display("-----------------------------------------RO_TEST-----------------------------------------------------");
		phase.drop_objection(this, "Objection Dropped");
	endtask : run_phase

endclass : ro_test


class rw_test extends apb_base_test;

	rw_seq seq;
	`uvm_component_utils(rw_test)

	function new(string name = "rw_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq = rw_seq::type_id::create("seq", this);
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		phase.phase_done.set_drain_time(this, 100ns);
		phase.raise_objection(this, "Objection Raised");
		seq.regmodel = env.regmodel;
		seq.start(env.agent_inst.seqr);
		$display("-----------------------------------------RW_TEST-----------------------------------------------------");
		phase.drop_objection(this, "Objection Dropped");
	endtask : run_phase

endclass : rw_test

class lock_test extends apb_base_test;

	lock_seq seq;
	`uvm_component_utils(lock_test)

	function new(string name = "lock_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq = lock_seq::type_id::create("seq", this);
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		phase.phase_done.set_drain_time(this, 100ns);
		phase.raise_objection(this, "Objection Raised");
		seq.regmodel = env.regmodel;
		seq.start(env.agent_inst.seqr);
	$display("-----------------------------------------LOCK_TEST-----------------------------------------------------");
		phase.drop_objection(this, "Objection Dropped");
	endtask : run_phase

endclass : lock_test

class gen_pkt_cfg_test extends apb_base_test;

	gen_pkt_cfg_seq seq;
	`uvm_component_utils(gen_pkt_cfg_test)

	function new(string name = "gen_pkt_cfg_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq = gen_pkt_cfg_seq::type_id::create("seq", this);
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		phase.phase_done.set_drain_time(this, 100ns);
		phase.raise_objection(this, "Objection Raised");
		seq.regmodel = env.regmodel;
		seq.start(env.agent_inst.seqr);
	$display("-----------------------------------------GEN_PKT_CFG_TEST-----------------------------------------------------");
		phase.drop_objection(this, "Objection Dropped");
	endtask : run_phase

endclass : gen_pkt_cfg_test

class switch_ctrl_test extends apb_base_test;

	switch_ctrl_seq seq;
	`uvm_component_utils(switch_ctrl_test)

	function new(string name = "switch_ctrl_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq = switch_ctrl_seq::type_id::create("seq", this);
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		phase.phase_done.set_drain_time(this, 100ns);
		phase.raise_objection(this, "Objection Raised");
		seq.regmodel = env.regmodel;
		seq.start(env.agent_inst.seqr);
	$display("-----------------------------------------SWITCH_CTRL_TEST-----------------------------------------------------");
		phase.drop_objection(this, "Objection Dropped");
	endtask : run_phase

endclass : switch_ctrl_test

class gen_ctrl_test extends apb_base_test;

	gen_ctrl_seq seq;
	`uvm_component_utils(gen_ctrl_test)

	function new(string name = "gen_ctrl_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq = gen_ctrl_seq::type_id::create("seq", this);
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		phase.phase_done.set_drain_time(this, 100ns);
		phase.raise_objection(this, "Objection Raised");
		seq.regmodel = env.regmodel;
		seq.start(env.agent_inst.seqr);
		$display("-----------------------------------------gen_ctrl_TEST-----------------------------------------------------");
		phase.drop_objection(this, "Objection Dropped");
	endtask : run_phase

endclass : gen_ctrl_test

class irq_test extends apb_base_test;

	irq_seq seq;
	`uvm_component_utils(irq_test)

	function new(string name = "irq_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq = irq_seq::type_id::create("seq", this);
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		phase.phase_done.set_drain_time(this, 100ns);
		phase.raise_objection(this, "Objection Raised");
		seq.regmodel = env.regmodel;
		seq.start(env.agent_inst.seqr);
	$display("-----------------------------------------IRQ_TEST-----------------------------------------------------");
		phase.drop_objection(this, "Objection Dropped");
	endtask : run_phase

endclass : irq_test

class err_test extends apb_base_test;

	err_seq seq;
	`uvm_component_utils(err_test)

	function new(string name = "err_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq = err_seq::type_id::create("seq", this);
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		phase.phase_done.set_drain_time(this, 100ns);
		phase.raise_objection(this, "Objection Raised");
		seq.regmodel = env.regmodel;
		seq.start(env.agent_inst.seqr);
	$display("-----------------------------------------ERR_TEST-----------------------------------------------------");
		phase.drop_objection(this, "Objection Dropped");
	endtask : run_phase

endclass : err_test

class soft_rst_test extends apb_base_test;

	soft_rst_seq seq;
	`uvm_component_utils(soft_rst_test)

	function new(string name = "soft_rst_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq = soft_rst_seq::type_id::create("seq", this);
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		phase.phase_done.set_drain_time(this, 100ns);
		phase.raise_objection(this, "Objection Raised");
		seq.regmodel = env.regmodel;
		seq.start(env.agent_inst.seqr);
	$display("-----------------------------------------SOFT_RESET_TEST-----------------------------------------------------");
		phase.drop_objection(this, "Objection Dropped");
	endtask : run_phase

endclass : soft_rst_test
