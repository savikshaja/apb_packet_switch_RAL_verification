class device_id extends uvm_reg;

	`uvm_object_utils(device_id)

	rand uvm_reg_field revision;
	rand uvm_reg_field vendor_id;
	rand uvm_reg_field product_id;

	function new(string name = "device_id");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction

	function void build();

		revision = uvm_reg_field::type_id::create("revision");
revision.configure(.parent(this), .size(8), .lsb_pos(24), .access("RO"), .volatile(0), .reset(8'h02), .has_reset(1), .is_rand(0), .individually_accessible(1));

		vendor_id = uvm_reg_field::type_id::create("vendor_id");	vendor_id.configure(.parent(this), .size(8), .lsb_pos(16), .access("RO"), .volatile(0), .reset(8'hA5), .has_reset(1), .is_rand(0), .individually_accessible(1));

		product_id = uvm_reg_field::type_id::create("product_id");
		product_id.configure(.parent(this), .size(16), .lsb_pos(0), .access("RO"), .volatile(0), .reset(16'h5357), .has_reset(1), .is_rand(0), .individually_accessible(1));

	endfunction

endclass
