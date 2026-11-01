class soft_reset extends uvm_reg;

	`uvm_object_utils(soft_reset)

	uvm_reg_field reserved;
	rand uvm_reg_field pulse;

	function new(string name = "soft_reset");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction

	function void build();

		reserved = uvm_reg_field::type_id::create("reserved");
		reserved.configure(.parent(this), .size(31), .lsb_pos(1), .access("RO"), .volatile(0), .reset(31'h00000000), .has_reset(1), .is_rand(0), .individually_accessible(1));

		pulse = uvm_reg_field::type_id::create("pulse");
		pulse.configure(.parent(this), .size(1), .lsb_pos(0), .access("WO"), .volatile(0), .reset(1'b0), .has_reset(1), .is_rand(0), .individually_accessible(1));

	endfunction

endclass
