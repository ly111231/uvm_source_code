`ifndef MY_DRIVER__SV
`define MY_DRIVER__SV

class my_driver extends uvm_driver;

    virtual my_if vif;
    `uvm_component_utils(my_driver)
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // `uvm_info(get_full_name(), "11", UVM_LOW);
        if(!uvm_config_db#(virtual my_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("my_driver", "vif not set!")
        end
    endfunction

    extern task main_phase(uvm_phase phase);
    extern task drive_one_pkt(my_transaction tr);

endclass

task my_driver::main_phase(uvm_phase phase);
    my_transaction tr;

    phase.raise_objection(this);
    vif.valid <= 1'b0;
    vif.data <= 8'd0;
    while(!vif.rst_n)
        @(posedge vif.clk);
    for(int i=0; i<2; ++i)begin
        tr = new("tr1");
        assert(tr.randomize() with {this.pload.size == 200;});
        drive_one_pkt(tr);
    end
    phase.drop_objection(this);
endtask

task my_driver::drive_one_pkt(my_transaction tr);

    byte unsigned data_array[];
    int data_size;
    data_size = tr.pack_bytes(data_array) / 8;
    `uvm_info("my_driver", "begin to drive one pkt", UVM_LOW);
    for(int i=0; i<data_size; ++i) begin
        @(posedge vif.clk);
        vif.data    <= data_array[i]; 
        vif.valid   <= 1'b1;
    end
    @(posedge vif.clk);
    vif.valid <= 1'b0;
    `uvm_info("my_driver", "one pkt is driverd", UVM_LOW);
endtask
`endif