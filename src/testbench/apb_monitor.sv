class apb_monitor extends uvm_monitor;
	`uvm_component_utils(apb_monitor)
	virtual apb_interface vif;
	apb_transaction monitor_item;
	uvm_analysis_port #(apb_transaction) monitor_port;

	function new(string name = "apb_monitor", uvm_component parent = null);
		super.new(name, parent);
		monitor_port = new("monitor_port", this);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(virtual apb_interface)::get(this, "", "vif", vif))
			`uvm_fatal(get_type_name(), "Config not set at top")
	endfunction : build_phase

	virtual task run_phase(uvm_phase phase);
		wait(vif.presetn == 1'b1);
		forever
		begin
			@(posedge vif.pclk);
			if(vif.psel && vif.penable && vif.pready)
			begin
				monitor_item = apb_transaction::type_id::create("monitor_item");
				monitor_item.psel    = vif.psel;
				monitor_item.penable = vif.penable;
				monitor_item.pwrite  = vif.pwrite;
				monitor_item.paddr   = vif.paddr;
				monitor_item.pwdata  = vif.pwdata;
				monitor_item.prdata  = vif.prdata;
				monitor_item.pready  = vif.pready;
				monitor_item.pslverr = vif.pslverr;
				`uvm_info("MON", $sformatf("%s addr=%0h wdata=%0h rdata=%0h err=%0b", monitor_item.pwrite ?"WR":"RD",monitor_item.paddr, monitor_item.pwdata, monitor_item.prdata, monitor_item.pslverr), UVM_HIGH)
				monitor_port.write(monitor_item);
			end
		end
	endtask : run_phase
endclass : apb_monitor
