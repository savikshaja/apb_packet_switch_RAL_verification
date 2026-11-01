
class apb_adapter extends uvm_reg_adapter;

	`uvm_object_utils(apb_adapter)

	function new(string name = "apb_adapter");
		super.new(name);
		supports_byte_enable = 0;
		provides_responses = 0;
	endfunction

	virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);

		apb_transaction tr;

		tr = apb_transaction::type_id::create("tr");

		tr.pwrite = (rw.kind == UVM_WRITE);
		tr.paddr  = rw.addr;
		tr.pwdata = rw.data;

		return tr;

	endfunction

	virtual function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);

		apb_transaction tr;

		if (!$cast(tr, bus_item)) begin
			rw.status = UVM_NOT_OK;
			return;
		end

		rw.kind   = tr.pwrite ? UVM_WRITE : UVM_READ;
		rw.addr   = tr.paddr;
		rw.data   = tr.pwrite ? tr.pwdata : tr.prdata;
		rw.status = tr.pslverr ? UVM_NOT_OK : UVM_IS_OK;

	endfunction

endclass

