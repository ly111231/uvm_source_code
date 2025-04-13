`ifndef MY_ENV__SV
`define MY_ENV__SV

class my_env extends uvm_env;
    my_driver drv;
    my_monitor i_mon;
    my_monitor o_mon;

    `uvm_component_utils(my_env)
    function new(string name = "my_env11", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        drv = my_driver::type_id::create("drv", this);
        i_mon = my_monitor::type_id::create("i_mon", this);
        o_mon = my_monitor::type_id::create("o_mon", this);
    endfunction

endclass
`endif