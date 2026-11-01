class switch_status extends uvm_reg;
	`uvm_object_utils(switch_status)
	rand uvm_reg_field gen_fsm;
	rand uvm_reg_field err_pending;
	rand uvm_reg_field gen_running;
	rand uvm_reg_field locked;
	rand uvm_reg_field switch_enabled;
	rand uvm_reg_field busy;
	rand uvm_reg_field ready;
	function new(string name = "switch_status");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction
	function void build();
		gen_fsm = uvm_reg_field::type_id::create("gen_fsm");
		gen_fsm.configure(.parent(this), .size(2), .lsb_pos(16), .access("RO"), .volatile(1), .reset(2'h0), .has_reset(1), .is_rand(0), .individually_accessible(1));
		err_pending = uvm_reg_field::type_id::create("err_pending");
		err_pending.configure(.parent(this), .size(1), .lsb_pos(9), .access("RO"), .volatile(1), .reset(1'h0), .has_reset(1), .is_rand(0), .individually_accessible(1));
		gen_running = uvm_reg_field::type_id::create("gen_running");
		gen_running.configure(.parent(this), .size(1), .lsb_pos(8), .access("RO"), .volatile(1), .reset(1'h0), .has_reset(1), .is_rand(0), .individually_accessible(1));
		locked = uvm_reg_field::type_id::create("locked");
		locked.configure(.parent(this), .size(1), .lsb_pos(3), .access("RO"), .volatile(1), .reset(1'h1), .has_reset(1), .is_rand(0), .individually_accessible(1));
		switch_enabled = uvm_reg_field::type_id::create("switch_enabled");
		switch_enabled.configure(.parent(this), .size(1), .lsb_pos(2), .access("RO"), .volatile(1), .reset(1'h0), .has_reset(1), .is_rand(0), .individually_accessible(1));
		busy = uvm_reg_field::type_id::create("busy");
		busy.configure(.parent(this), .size(1), .lsb_pos(1), .access("RO"), .volatile(1), .reset(1'h0), .has_reset(1), .is_rand(0), .individually_accessible(1));
		ready = uvm_reg_field::type_id::create("ready");
		ready.configure(.parent(this), .size(1), .lsb_pos(0), .access("RO"), .volatile(1), .reset(1'h1), .has_reset(1), .is_rand(0), .individually_accessible(1));
	endfunction
endclass
