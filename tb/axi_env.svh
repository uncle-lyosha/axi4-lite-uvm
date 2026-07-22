class axi_env extends uvm_env;
	`uvm_component_utils(axi_env)

	axi_agent_wr agent_wr;
	axi_agent_rd agent_rd;

	axi_scrb scrb;

	axi_coverage_wr cov_wr;
	axi_coverage_rd cov_rd;

	axi_reg_block reg_model;

	extern function new(string name, uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
 
endclass

function axi_env::new(string name, uvm_component parent);
	super.new(name, parent);
endfunction

function void axi_env::build_phase(uvm_phase phase);
	agent_rd = axi_agent_rd::type_id::create("agent_rd", this);
	agent_wr = axi_agent_wr::type_id::create("agent_wr", this);

	scrb = axi_scrb::type_id::create("scrb", this);

	reg_model = axi_reg_block::type_id::create("reg_model");
	reg_model.build();
	uvm_config_db#(axi_reg_block)::set(null, "*", "reg_model", reg_model);

	cov_wr = axi_coverage_wr::type_id::create("coverage_wr", this);
	cov_rd = axi_coverage_rd::type_id::create("coverage_rd", this);
endfunction

function void axi_env::connect_phase(uvm_phase phase);
	agent_wr.monitor_wr.axi_ap_i.connect(scrb.axi_ap_wr_i);
	agent_wr.monitor_wr.axi_ap_o.connect(scrb.axi_ap_wr_o);

	agent_rd.monitor_rd.axi_ap_i.connect(scrb.axi_ap_rd_i);
	agent_rd.monitor_rd.axi_ap_o.connect(scrb.axi_ap_rd_o);

	agent_wr.monitor_wr.axi_ap_i.connect(cov_wr.analysis_export);
	agent_rd.monitor_rd.axi_ap_i.connect(cov_rd.analysis_export);
endfunction