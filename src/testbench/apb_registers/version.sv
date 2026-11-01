class version extends uvm_reg;

	`uvm_object_utils(version)

	rand uvm_reg_field reserved;
	rand uvm_reg_field major;
	rand uvm_reg_field minor;
	rand uvm_reg_field patch;

	function new(string name = "version");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction

	function void build();

		reserved = uvm_reg_field::type_id::create("reserved");
		reserved.configure(.parent(this), .size(8), .lsb_pos(24), .access("RO"), .volatile(0), .reset(8'h00), .has_reset(1), .is_rand(0), .individually_accessible(1));

		major = uvm_reg_field::type_id::create("major");
		major.configure(.parent(this), .size(8), .lsb_pos(16), .access("RO"), .volatile(0), .reset(8'h01), .has_reset(1), .is_rand(0), .individually_accessible(1));

		minor = uvm_reg_field::type_id::create("minor");
		minor.configure(.parent(this), .size(8), .lsb_pos(8), .access("RO"), .volatile(0), .reset(8'h02), .has_reset(1), .is_rand(0), .individually_accessible(1));

		patch = uvm_reg_field::type_id::create("patch");
		patch.configure(.parent(this), .size(8), .lsb_pos(0), .access("RO"), .volatile(0), .reset(8'h00), .has_reset(1), .is_rand(0), .individually_accessible(1));

	endfunction

endclass
