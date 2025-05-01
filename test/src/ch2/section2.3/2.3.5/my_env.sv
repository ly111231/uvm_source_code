`ifndef MY_ENV__SV
`define MY_ENV__SV
class my_env extends uvm_env;
    my_agent i_agt;
    my_agent o_agt;
    uvm_tlm_analysis_fifo#(my_transaction) agt_mdl_fifo; //Transaction Level Modeling（事务级建模）
    my_model mdl;

    `uvm_component_utils(my_env)
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
endclass

function void my_env::build_phase(uvm_phase phase);
    super.build_phase(phase);
    i_agt = my_agent::type_id::create("i_agt", this);
    o_agt = my_agent::type_id::create("o_agt", this);
    i_agt.is_active = UVM_ACTIVE;
    o_agt.is_active = UVM_PASSIVE;
    mdl = my_model::type_id::create("mdl", this);
    agt_mdl_fifo = new("agt_mdl_fifffo", this);
endfunction

function void my_env::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    i_agt.ap.connect(agt_mdl_fifo.analysis_export);
    mdl.port.connect(agt_mdl_fifo.blocking_get_export);
endfunction
`endif