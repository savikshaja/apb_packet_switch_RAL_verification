class lock extends uvm_reg;

	`uvm_object_utils(lock)

	uvm_reg_field reserved;
	rand uvm_reg_field locked;

	function new(string name = "lock");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction

	function void build();

		reserved = uvm_reg_field::type_id::create("reserved");
		reserved.configure(.parent(this), .size(31), .lsb_pos(1), .access("RO"), .volatile(0), .reset(31'h00000000), .has_reset(1), .is_rand(0), .individually_accessible(1));

		locked = uvm_reg_field::type_id::create("locked");
		locked.configure(.parent(this), .size(1), .lsb_pos(0), .access("RO"), .volatile(1), .reset(1'b1), .has_reset(1), .is_rand(0), .individually_accessible(1));

	endfunction

endclass
