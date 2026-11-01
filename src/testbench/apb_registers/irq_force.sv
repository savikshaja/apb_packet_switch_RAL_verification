class irq_force extends uvm_reg;

	`uvm_object_utils(irq_force)

	uvm_reg_field reserved;
	rand uvm_reg_field force_bits;

	function new(string name = "irq_force");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction

	function void build();

		reserved = uvm_reg_field::type_id::create("reserved");
		reserved.configure(.parent(this), .size(24), .lsb_pos(8), .access("RO"), .volatile(0), .reset(24'h000000), .has_reset(1), .is_rand(0), .individually_accessible(1));

		force_bits = uvm_reg_field::type_id::create("force_bits");
		force_bits.configure(.parent(this), .size(8), .lsb_pos(0), .access("WO"), .volatile(0), .reset(8'h00), .has_reset(1), .is_rand(0), .individually_accessible(1));

	endfunction

endclass
