`ifndef MY_MODEL__SV
`define MY_MODEL__SV
class my_model extends uvm_component;

    uvm_blocking_get_port #(my_transaction) port;
    uvm_analysis_port #(my_transaction) ap;

    `uvm_component_utils(my_model);
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    extern function void build_phase(uvm_phase phase);
    extern virtual task main_phase(uvm_phase phase);
endclass

function void my_model::build_phase(uvm_phase phase);
    super.build_phase(phase);
    port = new("port", this);
    ap = new("ap", this);
endfunction

task my_model::main_phase(uvm_phase phase);
    my_transaction tr, new_tr;

    super.main_phase(phase);
    while(1)begin
        port.get(tr);
        new_tr = new("new_tr"); // tr不用例化是因为传来的是model中的tr本体，这里只需指向其即可
        new_tr.my_copy(tr);
        `uvm_info("my_model", "get one transaction, copy and print it:", UVM_LOW)
        new_tr.my_print();
        ap.write(new_tr);
    end
endtask
`endif 