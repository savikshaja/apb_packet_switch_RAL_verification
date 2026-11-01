class stat_rx extends uvm_reg;

	`uvm_object_utils(stat_rx)

	uvm_reg_field reserved;
	uvm_reg_field rx_packets;

	function new(string name = "stat_rx");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction

	function void build();

		reserved = uvm_reg_field::type_id::create("reserved");
		reserved.configure(.parent(this), .size(16), .lsb_pos(16), .access("RO"), .volatile(0), .reset(16'h0000), .has_reset(1), .is_rand(0), .individually_accessible(1));

		rx_packets = uvm_reg_field::type_id::create("rx_packets");
		rx_packets.configure(.parent(this), .size(16), .lsb_pos(0), .access("RO"), .volatile(1), .reset(16'h0000), .has_reset(1), .is_rand(0), .individually_accessible(1));

	endfunction

endclass
