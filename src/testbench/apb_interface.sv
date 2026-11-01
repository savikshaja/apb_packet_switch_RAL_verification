interface apb_interface(input logic pclk, input logic presetn);
	logic psel;
	logic penable;
	logic pwrite;
	logic [15:0] paddr;
	logic [31:0] pwdata;
	logic [31:0] prdata;
	logic pready;
	logic pslverr;
	logic irq;
endinterface
