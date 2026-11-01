
class switch_ctrl extends uvm_reg;

	`uvm_object_utils(switch_ctrl)

	rand uvm_reg_field enable;
	uvm_reg_field reserved;

	function new(string name = "switch_ctrl");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction

	virtual function void build();
		enable = uvm_reg_field::type_id::create("enable");
		enable.configure(this, 1, 0, "RW", 0, 1'b0, 1, 0, 1);

		reserved = uvm_reg_field::type_id::create("reserved");
		reserved.configure(this, 31, 1, "RO", 0, 31'b0, 1, 0, 0);
	endfunction

endclass

