
class apb_env extends uvm_env;

	`uvm_component_utils(apb_env)

	apb_agent agent_inst;
	apb_subscriber sub;
	reg_block regmodel;
	apb_adapter adapter_inst;
	uvm_reg_predictor #(apb_transaction) predictor;

	function new(string name = "apb_env", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		agent_inst = apb_agent::type_id::create("agent_inst", this);
		sub = apb_subscriber::type_id::create("sub", this);
		regmodel = reg_block::type_id::create("regmodel", this);
		adapter_inst = apb_adapter::type_id::create("adapter_inst");
		predictor = uvm_reg_predictor#(apb_transaction)::type_id::create("predictor", this);
		uvm_config_db #(uvm_active_passive_enum)::set(this, "agent_inst", "is_active", UVM_ACTIVE);
		regmodel.build();

	endfunction

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);

		regmodel.default_map.set_base_addr(0);
		regmodel.default_map.set_sequencer(.sequencer(agent_inst.seqr),	.adapter(adapter_inst));
		regmodel.default_map.set_auto_predict(0);
		predictor.map = regmodel.default_map;
		predictor.adapter = adapter_inst;
		agent_inst.mon.monitor_port.connect(predictor.bus_in);
		agent_inst.mon.monitor_port.connect(sub.analysis_export);
	endfunction

endclass

