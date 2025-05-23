`ifndef MY_DRIVER__SV
`define MY_DRIVER__SV
class my_driver extends uvm_driver;
    `uvm_component_utils(my_driver)
    function new(string name = "my_driver11", uvm_component parent = null);
        super.new(name, parent);
        `uvm_info("my_driver222", "new is called", UVM_LOW);
        `uvm_info(get_full_name(), "data sent111", UVM_LOW);
    endfunction
    extern virtual task main_phase(uvm_phase phase);
endclass

task my_driver::main_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_info("my_driver333", "main_phase is called", UVM_LOW);
    `uvm_info(get_full_name(), "data sent222", UVM_LOW);
    top_tb.rxd <= 8'd0;
    top_tb.rx_dv <= 1'b0;
    while(!top_tb.rst_n)
        @(posedge top_tb.clk);
    for(int i=0; i<64; i++)begin
        @(posedge top_tb.clk);
        top_tb.rxd <= $urandom_range(0, 255);
        top_tb.rx_dv <= 1'b1;
        `uvm_info("my_driver444", "data is drived", UVM_LOW);
    end
    @(posedge top_tb.clk);
    top_tb.rx_dv <= 0;
    phase.drop_objection(this);
endtask
`endif 