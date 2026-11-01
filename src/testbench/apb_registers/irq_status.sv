class irq_status extends uvm_reg;

	`uvm_object_utils(irq_status)

	uvm_reg_field reserved;
	rand uvm_reg_field sw_event;
	rand uvm_reg_field start_ack;
	rand uvm_reg_field queue_almost_full;
	rand uvm_reg_field packet_forwarded;
	rand uvm_reg_field packet_dropped;
	rand uvm_reg_field queue_overflow;
	rand uvm_reg_field error;
	rand uvm_reg_field gen_done;

	function new(string name = "irq_status");
		super.new(name, 32, UVM_NO_COVERAGE);
	endfunction

	function void build();

		reserved = uvm_reg_field::type_id::create("reserved");
		reserved.configure(.parent(this), .size(24), .lsb_pos(8), .access("RO"), .volatile(0), .reset(24'h000000), .has_reset(1), .is_rand(0), .individually_accessible(1));

		sw_event = uvm_reg_field::type_id::create("sw_event");
		sw_event.configure(.parent(this), .size(1), .lsb_pos(7), .access("W1C"), .volatile(1), .reset(1'b0), .has_reset(1), .is_rand(0), .individually_accessible(1));

		start_ack = uvm_reg_field::type_id::create("start_ack");
		start_ack.configure(.parent(this), .size(1), .lsb_pos(6), .access("W1C"), .volatile(1), .reset(1'b0), .has_reset(1), .is_rand(0), .individually_accessible(1));

		queue_almost_full = uvm_reg_field::type_id::create("queue_almost_full");
		queue_almost_full.configure(.parent(this), .size(1), .lsb_pos(5), .access("W1C"), .volatile(1), .reset(1'b0), .has_reset(1), .is_rand(0), .individually_accessible(1));

		packet_forwarded = uvm_reg_field::type_id::create("packet_forwarded");
		packet_forwarded.configure(.parent(this), .size(1), .lsb_pos(4), .access("W1C"), .volatile(1), .reset(1'b0), .has_reset(1), .is_rand(0), .individually_accessible(1));

		packet_dropped = uvm_reg_field::type_id::create("packet_dropped");
		packet_dropped.configure(.parent(this), .size(1), .lsb_pos(3), .access("W1C"), .volatile(1), .reset(1'b0), .has_reset(1), .is_rand(0), .individually_accessible(1));

		queue_overflow = uvm_reg_field::type_id::create("queue_overflow");
		queue_overflow.configure(.parent(this), .size(1), .lsb_pos(2), .access("W1C"), .volatile(1), .reset(1'b0), .has_reset(1), .is_rand(0), .individually_accessible(1));

		error = uvm_reg_field::type_id::create("error");
		error.configure(.parent(this), .size(1), .lsb_pos(1), .access("W1C"), .volatile(1), .reset(1'b0), .has_reset(1), .is_rand(0), .individually_accessible(1));

		gen_done = uvm_reg_field::type_id::create("gen_done");
		gen_done.configure(.parent(this), .size(1), .lsb_pos(0), .access("W1C"), .volatile(1), .reset(1'b0), .has_reset(1), .is_rand(0), .individually_accessible(1));

	endfunction

endclass
