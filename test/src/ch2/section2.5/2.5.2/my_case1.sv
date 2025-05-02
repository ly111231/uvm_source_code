`ifndef MY_CASE1__SV
`define MY_CASE1__SV
class case1_sequence extends uvm_sequence #(my_transaction);
    my_transaction m_trans;

    `uvm_object_utils(case1_sequence);
    function new(string name = "case1");
        super.new(name);
    endfunction

    virtual task body();
        if(starting_phase != null)
            starting_phase.raise_objection(this);
        repeat(10) begin
            `uvm_do_with(m_trans, {this.pload.size() == 60;})
        end
        #100;
        if(starting_phase != null)
            starting_phase.drop_objection(this);
    endtask
endclass

class my_case1 extends base_test;
    `uvm_component_utils(my_case1);
    // my_env  env;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    extern virtual function void build_phase(uvm_phase phase);
endclass
function void my_case1::build_phase(uvm_phase phase);
    super.build_phase(phase);

    // env = my_env::type_id::create("env", this);
    uvm_config_db #(uvm_object_wrapper)::set(this,
                                            "env.i_agt.sqr.main_phase",
                                            "default_sequence",
                                            case1_sequence::type_id::get());
endfunction
`endif