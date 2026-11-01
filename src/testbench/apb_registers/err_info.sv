class err_info extends uvm_reg;

	`uvm_object_utils(err_info)

	rand uvm_reg_field tx_snapshot;
	rand uvm_reg_field reserved;
	rand uvm_reg_field dest_port;
	rand uvm_reg_field source;
	rand uvm_reg_field last_code;

	function new(string name = "err_info");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction

	function void build();

		tx_snapshot = uvm_reg_field::type_id::create("tx_snapshot");
		tx_snapshot.configure(.parent(this), .size(12), .lsb_pos(20), .access("RO"), .volatile(1), .reset(12'h000), .has_reset(1), .is_rand(0), .individually_accessible(1));

		reserved = uvm_reg_field::type_id::create("reserved");
		reserved.configure(.parent(this), .size(2), .lsb_pos(18), .access("RO"), .volatile(0), .reset(2'b00), .has_reset(1), .is_rand(0), .individually_accessible(1));

		dest_port = uvm_reg_field::type_id::create("dest_port");
		dest_port.configure(.parent(this), .size(2), .lsb_pos(16), .access("RO"), .volatile(1), .reset(2'b00), .has_reset(1), .is_rand(0), .individually_accessible(1));

		source = uvm_reg_field::type_id::create("source");
		source.configure(.parent(this), .size(8), .lsb_pos(8), .access("RO"), .volatile(1), .reset(8'h00), .has_reset(1), .is_rand(0), .individually_accessible(1));

		last_code = uvm_reg_field::type_id::create("last_code");
		last_code.configure(.parent(this), .size(8), .lsb_pos(0), .access("RO"), .volatile(1), .reset(8'h00), .has_reset(1), .is_rand(0), .individually_accessible(1));

	endfunction

endclass
