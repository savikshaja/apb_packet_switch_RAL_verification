class port_enable extends uvm_reg;

	`uvm_object_utils(port_enable)

	uvm_reg_field reserved;
	rand uvm_reg_field port3_en;
	rand uvm_reg_field port2_en;
	rand uvm_reg_field port1_en;
	rand uvm_reg_field port0_en;

	function new(string name = "port_enable");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction

	function void build();

		reserved = uvm_reg_field::type_id::create("reserved");
		reserved.configure(.parent(this), .size(28), .lsb_pos(4), .access("RO"), .volatile(0), .reset(28'h0000000), .has_reset(1), .is_rand(0), .individually_accessible(1));

		port3_en = uvm_reg_field::type_id::create("port3_en");
		port3_en.configure(.parent(this), .size(1), .lsb_pos(3), .access("RW"), .volatile(0), .reset(1'b1), .has_reset(1), .is_rand(1), .individually_accessible(1));

		port2_en = uvm_reg_field::type_id::create("port2_en");
		port2_en.configure(.parent(this), .size(1), .lsb_pos(2), .access("RW"), .volatile(0), .reset(1'b1), .has_reset(1), .is_rand(1), .individually_accessible(1));

		port1_en = uvm_reg_field::type_id::create("port1_en");
		port1_en.configure(.parent(this), .size(1), .lsb_pos(1), .access("RW"), .volatile(0), .reset(1'b1), .has_reset(1), .is_rand(1), .individually_accessible(1));

		port0_en = uvm_reg_field::type_id::create("port0_en");
		port0_en.configure(.parent(this), .size(1), .lsb_pos(0), .access("RW"), .volatile(0), .reset(1'b1), .has_reset(1), .is_rand(1), .individually_accessible(1));

	endfunction

endclass
