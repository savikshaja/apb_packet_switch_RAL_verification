class apb_subscriber extends uvm_subscriber #(apb_transaction);

	`uvm_component_utils(apb_subscriber)
	apb_transaction monitor_trans;

	covergroup input_cov();
		addr_cp : coverpoint monitor_trans.paddr {
			bins device_id     = {32'h00};
			bins version       = {32'h04};
			bins switch_status = {32'h08};
			bins port_status   = {32'h0C};
			bins gen_status    = {32'h10};
			bins stat_rx       = {32'h14};
			bins stat_tx       = {32'h18};
			bins stat_drop     = {32'h1C};
			bins switch_ctrl   = {32'h20};
			bins port_enable   = {32'h24};
			bins fwd_enable    = {32'h28};
			bins gen_ctrl      = {32'h2C};
			bins gen_pkt_cfg   = {32'h30};
			bins gen_interval  = {32'h34};
			bins gen_count     = {32'h38};
			bins irq_status    = {32'h3C};
			bins irq_enable    = {32'h40};
			bins irq_force     = {32'h44};
			bins err_status    = {32'h48};
			bins err_enable    = {32'h4C};
			bins err_inject    = {32'h50};
			bins err_count     = {32'h54};
			bins err_info      = {32'h58};
			bins lock          = {32'h5C};
			bins soft_reset    = {32'h60};
		}
		wr_cp : coverpoint monitor_trans.pwrite {
			bins read  = {0};
			bins write = {1};
		}
		wdata_cp : coverpoint monitor_trans.pwdata iff (monitor_trans.pwrite) {
			bins zero       = {32'h0};
			bins all_ones   = {32'hFFFF_FFFF};
			bins unlock_key = {32'hA5A5_C3C3};
			//bins other      = default;
		}
		addr_wr_cross : cross addr_cp, wr_cp;
	endgroup

	function new(string name = "apb_subscriber", uvm_component parent = null);
		super.new(name, parent);
		input_cov = new();
	endfunction : new

	function void write (apb_transaction t);
		monitor_trans = t;
		input_cov.sample();
	endfunction : write

	function void report_phase(uvm_phase phase);
		super.report_phase(phase);
		`uvm_info(get_type_name(), $sformatf("Input Coverage = %0.2f", input_cov.get_coverage()), UVM_MEDIUM);
	endfunction : report_phase

endclass : apb_subscriber
