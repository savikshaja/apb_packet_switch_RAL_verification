class err_count extends uvm_reg;

	`uvm_object_utils(err_count)

	uvm_reg_field reserved;
	rand uvm_reg_field error_count;

	function new(string name = "err_count");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction

	function void build();

		reserved = uvm_reg_field::type_id::create("reserved");
		reserved.configure(.parent(this), .size(16), .lsb_pos(16), .access("RO"), .volatile(0), .reset(16'h0000), .has_reset(1), .is_rand(0), .individually_accessible(1));

		error_count = uvm_reg_field::type_id::create("error_count");
		error_count.configure(.parent(this), .size(16), .lsb_pos(0), .access("RO"), .volatile(1), .reset(16'h0000), .has_reset(1), .is_rand(0), .individually_accessible(1));

	endfunction

endclass
