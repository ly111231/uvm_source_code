`ifndef MY_MONITOR__SV
`define MY_MONITOR__SV
class my_monitor extends uvm_monitor;

    virtual my_if vif;
    uvm_analysis_port#(my_transaction) ap;

    `uvm_component_utils(my_monitor);
    function new(string name, uvm_component parent);
         super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual my_if)::get(this, "", "vif", vif))
            `uvm_fatal("my_monitor", "vif not set");
        ap = new("ap", this);
    endfunction

    extern task main_phase(uvm_phase phase);
    extern task collect_one_pkt(my_transaction tr);

endclass

task my_monitor::main_phase(uvm_phase phase);
    my_transaction tr;
    while(1)begin
        tr = new("tr");
        collect_one_pkt(tr);
        ap.write(tr);
    end
endtask

task my_monitor::collect_one_pkt(my_transaction tr);
    bit [7:0]   data_q[$];
    int psize;

    while(1)begin
        @(posedge vif.clk);
        if(vif.valid) break;
    end

    `uvm_info(" my_monitor", "begin to collect one pkt", UVM_LOW);
    while(vif.valid)begin
        data_q.push_back(vif.data);
        @(posedge vif.clk);
    end

    for(int i=0; i<6; ++i)
        tr.dmac = {tr.dmac[39:0], data_q.pop_front()};
    for(int i=0; i<6; ++i)
        tr.smac = {tr.smac[39:0], data_q.pop_front()};
    for(int i=0; i<2; ++i)
        tr.ether_type = {tr.ether_type[7:0], data_q.pop_front()};
    
    psize = data_q.size - 4;
    tr.pload = new[psize];
    for(int i=0; i<psize; ++i)
        tr.pload[i] = data_q.pop_front();

    for(int i=0; i<4; ++i)
        tr.crc = {tr.crc[23:0], data_q.pop_front()};
    `uvm_info(" my_monitor", "end of collect one pkt", UVM_LOW);
    tr.my_print();
endtask
`endif