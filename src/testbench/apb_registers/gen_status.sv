class gen_status extends uvm_reg;

	`uvm_object_utils(gen_status)

	uvm_reg_field reserved_31_24;
	rand uvm_reg_field remaining;
	uvm_reg_field reserved_7_4;
	rand uvm_reg_field fsm;
	rand uvm_reg_field done;
	rand uvm_reg_field running;

	function new(string name = "gen_status");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction

	function void build();

		reserved_31_24 = uvm_reg_field::type_id::create("reserved_31_24");
		reserved_31_24.configure(.parent(this), .size(8), .lsb_pos(24), .access("RO"), .volatile(0), .reset(8'h00), .has_reset(1), .is_rand(0), .individually_accessible(1));

		remaining = uvm_reg_field::type_id::create("remaining");
		remaining.configure(.parent(this), .size(16), .lsb_pos(8), .access("RO"), .volatile(1), .reset(16'h0000), .has_reset(1), .is_rand(0), .individually_accessible(1));

		reserved_7_4 = uvm_reg_field::type_id::create("reserved_7_4");
		reserved_7_4.configure(.parent(this), .size(4), .lsb_pos(4), .access("RO"), .volatile(0), .reset(4'h0), .has_reset(1), .is_rand(0), .individually_accessible(1));

		fsm = uvm_reg_field::type_id::create("fsm");
		fsm.configure(.parent(this), .size(2), .lsb_pos(2), .access("RO"), .volatile(1), .reset(2'b00), .has_reset(1), .is_rand(0), .individually_accessible(1));

		done = uvm_reg_field::type_id::create("done");
		done.configure(.parent(this), .size(1), .lsb_pos(1), .access("RO"), .volatile(1), .reset(1'b0), .has_reset(1), .is_rand(0), .individually_accessible(1));

		running = uvm_reg_field::type_id::create("running");
		running.configure(.parent(this), .size(1), .lsb_pos(0), .access("RO"), .volatile(1), .reset(1'b0), .has_reset(1), .is_rand(0), .individually_accessible(1));

	endfunction

endclass
