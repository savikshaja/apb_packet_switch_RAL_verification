class gen_count extends uvm_reg;

	`uvm_object_utils(gen_count)

	uvm_reg_field reserved;
	rand uvm_reg_field count;

	function new(string name = "gen_count");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction

	function void build();

		reserved = uvm_reg_field::type_id::create("reserved");
		reserved.configure(.parent(this), .size(16), .lsb_pos(16), .access("RO"), .volatile(0), .reset(16'h0000), .has_reset(1), .is_rand(0), .individually_accessible(1));

		count = uvm_reg_field::type_id::create("count");
		count.configure(.parent(this), .size(16), .lsb_pos(0), .access("RW"), .volatile(0), .reset(16'h0004), .has_reset(1), .is_rand(1), .individually_accessible(1));

	endfunction

endclass
