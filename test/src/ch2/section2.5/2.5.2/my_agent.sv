`ifndef MY_AGENT__SV
`define MY_AGENT__SV
class my_agent extends uvm_agent;
    my_driver drv;
    my_monitor mon;
    my_sequencer sqr;

    uvm_analysis_port#(my_transaction) ap;

    `uvm_component_utils(my_agent)
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    extern virtual function void build_phase(uvm_phase phase);
    extern virtual function void connect_phase(uvm_phase phase);
endclass

function void my_agent::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(is_active == UVM_ACTIVE)begin
        drv = my_driver::type_id::create("drv", this);
        sqr = my_sequencer::type_id::create("sqr", this);
    end
    mon = my_monitor::type_id::create("mon", this);
endfunction

function void my_agent::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(is_active == UVM_ACTIVE)
        drv.seq_item_port.connect(sqr.seq_item_export);
    ap = mon.ap;
endfunction

`endif 