`ifndef MY_SEQUENCE__SV
`define MY_SEQUENCE__SV
class my_sequence extends uvm_sequence #(my_transaction);
    my_transaction trans;

    `uvm_object_utils(my_sequence);

    function new(string name = "2"); //todo 此处名字不能为空？
        super.new(name);
    endfunction

    virtual task body();
        if(starting_phase != null)
            starting_phase.raise_objection(this);
        repeat(5)begin
            `uvm_do(trans);
        end
        #100;
        if(starting_phase != null)
            starting_phase.drop_objection(this);
    endtask
endclass
`endif