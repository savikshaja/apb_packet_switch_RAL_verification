
`include "apb_interface.sv"
`include "apb_pkg.sv"

module tb;

	import uvm_pkg::*;
	import apb_pkg::*;

	bit pclk;
	bit presetn;

	always #5 pclk = ~pclk;

	apb_interface vif(pclk, presetn);
	  apb_pkt_switch dut (
.pclk    (pclk),
  .presetn (presetn),

  .psel    (vif.psel),
  .penable (vif.penable),
  .pwrite  (vif.pwrite),
  .paddr   (vif.paddr),
  .pwdata  (vif.pwdata),
  .prdata  (vif.prdata),
  .pready  (vif.pready),
  .pslverr (vif.pslverr),
  .irq     (vif.irq)
);

	initial begin
		presetn = 1'b0;
		repeat (5) @(posedge pclk);
		presetn = 1'b1;
	end

	initial begin
		uvm_config_db#(virtual apb_interface)::set(
			null,
			"*",
			"vif",
			vif
		);

		run_test("test");
	end

endmodule

