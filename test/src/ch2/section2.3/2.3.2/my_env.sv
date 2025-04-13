`ifndef MY_ENV__SV
`define MY_ENV__SV

class my_env extends uvm_env;
    my_driver drv;

    `uvm_component_utils(my_env);
    function new(string name = "my_env11", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        drv = my_driver::type_id::create("drv", this);
    endfunction

endclass
`endif