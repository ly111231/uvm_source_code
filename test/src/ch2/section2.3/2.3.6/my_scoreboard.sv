`ifndef MY_SCOREBOARD__SV
`define MY_SCOREBOARD__SV
class my_scoreboard extends uvm_scoreboard;
    uvm_blocking_get_port #(my_transaction) act_port, exp_port;
    my_transaction expect_queue[$];

    `uvm_component_utils(my_scoreboard)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    extern virtual function void build_phase(uvm_phase phase);
    extern virtual task main_phase(uvm_phase phase);
endclass
function void my_scoreboard::build_phase(uvm_phase phase);
    super.build_phase(phase);
    act_port = new("act_port", this);
    exp_port = new("exp_port", this);
endfunction

task my_scoreboard::main_phase(uvm_phase phase);
    my_transaction get_actual, get_expect, tmp_tran;
    bit result;
    fork
        while (1) begin
           exp_port.get(get_expect);
           expect_queue.push_back(get_expect);
        end
        while (1) begin
            act_port.get(get_actual);
            if(expect_queue.size() > 0)begin
                tmp_tran = expect_queue.pop_front();
                result = get_actual.my_compare(tmp_tran);
                if(result) begin
                    `uvm_info("my_scoreboard", "Compare SUCCESSFULLY", UVM_LOW);
                end else begin
                    `uvm_error("my_scoreboard", "Compare FAILED");
                    $display("the expect pkt is");
                    tmp_tran.my_print();
                    $display("the actual pkt is");
                    get_actual.my_print();
                end
            end else begin
                `uvm_error("my_scoreboard", "Received from DUT, while Expect Queue is empty");
                $display("the unexpected pkt is");
                get_actual.my_print();
            end
        end
    join
endtask

`endif