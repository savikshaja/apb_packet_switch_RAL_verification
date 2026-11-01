class gen_interval extends uvm_reg;

	`uvm_object_utils(gen_interval)

	uvm_reg_field reserved;
	rand uvm_reg_field interval;

	function new(string name = "gen_interval");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction

	function void build();

		reserved = uvm_reg_field::type_id::create("reserved");
		reserved.configure(.parent(this), .size(16), .lsb_pos(16), .access("RO"), .volatile(0), .reset(16'h0000), .has_reset(1), .is_rand(0), .individually_accessible(1));

		interval = uvm_reg_field::type_id::create("interval");
		interval.configure(.parent(this), .size(16), .lsb_pos(0), .access("RW"), .volatile(0), .reset(16'h0002), .has_reset(1), .is_rand(1), .individually_accessible(1));

	endfunction

endclass
