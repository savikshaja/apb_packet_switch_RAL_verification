import uvm_pkg::*;
`include "uvm_macros.svh"
class apb_transaction extends uvm_sequence_item;

	`uvm_object_utils(apb_transaction)

	rand bit psel;
	rand bit penable;
	rand bit pwrite;
	rand bit [31:0] paddr;
	rand bit [31:0] pwdata;
	//rand bit [2:0] pprot;

	bit [31:0] prdata;
	bit pready;
	bit pslverr;

	function new(string name = "apb_transaction");
		super.new(name);
	endfunction
	constraint addr_c {
	paddr inside {[32'h00:32'h60]};
	paddr[1:0] == 2'b00;
	}

endclass
