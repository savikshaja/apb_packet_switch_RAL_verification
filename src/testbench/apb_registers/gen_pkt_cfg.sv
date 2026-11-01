class gen_pkt_cfg extends uvm_reg;

	`uvm_object_utils(gen_pkt_cfg)

	uvm_reg_field reserved_31_24;
	rand uvm_reg_field seed;
	rand uvm_reg_field length;
	uvm_reg_field reserved_7_4;
	rand uvm_reg_field src_port;
	rand uvm_reg_field dst_port;

	function new(string name = "gen_pkt_cfg");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction

	function void build();

		reserved_31_24 = uvm_reg_field::type_id::create("reserved_31_24");
		reserved_31_24.configure(.parent(this), .size(8), .lsb_pos(24), .access("RO"), .volatile(0), .reset(8'h00), .has_reset(1), .is_rand(0), .individually_accessible(1));

		seed = uvm_reg_field::type_id::create("seed");
		seed.configure(.parent(this), .size(8), .lsb_pos(16), .access("RW"), .volatile(0), .reset(8'h00), .has_reset(1), .is_rand(1), .individually_accessible(1));

		length = uvm_reg_field::type_id::create("length");
		length.configure(.parent(this), .size(8), .lsb_pos(8), .access("RW"), .volatile(0), .reset(8'h04), .has_reset(1), .is_rand(1), .individually_accessible(1));

		reserved_7_4 = uvm_reg_field::type_id::create("reserved_7_4");
		reserved_7_4.configure(.parent(this), .size(4), .lsb_pos(4), .access("RO"), .volatile(0), .reset(4'h0), .has_reset(1), .is_rand(0), .individually_accessible(1));

		src_port = uvm_reg_field::type_id::create("src_port");
		src_port.configure(.parent(this), .size(2), .lsb_pos(2), .access("RW"), .volatile(0), .reset(2'b00), .has_reset(1), .is_rand(1), .individually_accessible(1));

		dst_port = uvm_reg_field::type_id::create("dst_port");
		dst_port.configure(.parent(this), .size(2), .lsb_pos(0), .access("RW"), .volatile(0), .reset(2'b01), .has_reset(1), .is_rand(1), .individually_accessible(1));

	endfunction

endclass
