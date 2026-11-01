
class port_status extends uvm_reg;
	`uvm_object_utils(port_status)

	rand uvm_reg_field port3_level;
	rand uvm_reg_field port2_level;
	rand uvm_reg_field port1_level;
	rand uvm_reg_field port0_level;

	function new(string name = "port_status");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction

	function void build();

		port3_level = uvm_reg_field::type_id::create("port3_level");
		port3_level.configure(.parent(this), .size(8), .lsb_pos(24), .access("RO"), .volatile(1), .reset(8'h00), .has_reset(1), .is_rand(0), .individually_accessible(1));

		port2_level = uvm_reg_field::type_id::create("port2_level");
		port2_level.configure(.parent(this), .size(8), .lsb_pos(16), .access("RO"), .volatile(1), .reset(8'h00), .has_reset(1), .is_rand(0), .individually_accessible(1));

		port1_level = uvm_reg_field::type_id::create("port1_level");
		port1_level.configure(.parent(this), .size(8), .lsb_pos(8), .access("RO"), .volatile(1), .reset(8'h00), .has_reset(1), .is_rand(0), .individually_accessible(1));

		port0_level = uvm_reg_field::type_id::create("port0_level");
		port0_level.configure(.parent(this), .size(8), .lsb_pos(0), .access("RO"), .volatile(1), .reset(8'h00), .has_reset(1), .is_rand(0), .individually_accessible(1));

	endfunction
endclass

