`ifndef MY_DRIVER__SV
`define MY_DRIVER__SV

class my_driver extends uvm_driver;

    virtual my_if vif;
    `uvm_component_utils(my_driver)
    function new(string name = "my_driver11", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("mydriver", "build phase is called", UVM_LOW);
        if(!uvm_config_db#(virtual my_if)::get(this, "", "vif", vif))
            `uvm_fatal("mydriver", "virtual interface must be set for vif!!!")
    endfunction
    
    extern task main_phase(uvm_phase phase);
    extern task drive_one_pkt(my_transaction tr);
endclass

task my_driver::main_phase(uvm_phase phase);
    my_transaction tr;
    phase.raise_objection(this);

    vif.data <= 8'd0;
    vif.valid <= 1'b0;

    while(!vif.rst_n)
        @(posedge vif.clk);
    for(int i=0; i<2; i++)begin
        tr = new("tr");
        assert(tr.randomize() with {this.pload.size == 200;}); //todo
        drive_one_pkt(tr);
    end
    repeat(5) @(posedge vif.clk);
    phase.drop_objection(this);
endtask

task my_driver::drive_one_pkt(my_transaction tr);
    bit [47:0]  tmp_data;
    bit [7:0]   data_q[$];

    tmp_data = tr.dmac;
    for(int i=0; i<6; ++i)begin
        data_q.push_back(tmp_data[7:0]);
        tmp_data = (tmp_data >> 8);
    end

    tmp_data = tr.smac;
    for(int i=0; i<6; ++i)begin
        data_q.push_back(tmp_data[7:0]);
        tmp_data = (tmp_data >> 8);
    end

    tmp_data = tr.ether_type;
    for(int i=0; i<2; ++i)begin
        data_q.push_back(tmp_data[7:0]);
        tmp_data = (tmp_data >> 8);
    end
    // transfer pload
    for(int i=0; i<tr.pload.size; ++i)begin
        data_q.push_back(tr.pload[i]);
    end

    tmp_data = tr.crc;
    for(int i=0; i<4; ++i)begin
        data_q.push_back(tmp_data[7:0]);
        tmp_data = (tmp_data >> 8);
    end
    repeat(3) @(posedge vif.clk);
    while(data_q.size() > 0) begin
        @(posedge vif.clk);
        vif.data <= data_q.pop_front();
        vif.valid <= 1'b1;
    end
    @(posedge vif.clk);
    vif.valid <= 0;
    `uvm_info("my_driver", "one pkt has been drivered", UVM_LOW);
endtask

`endif 