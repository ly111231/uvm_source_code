`timescale 1ns/1ps
`include "uvm_macros.svh"

import uvm_pkg::*;
`include "my_driver.sv"
`include "my_if.sv"

module top_tb ();

    reg     clk;
    reg     rst_n;
    reg     [7:0]   rxd;
    reg     rx_dv;
    wire    [7:0]   txd;
    wire    tx_en;
    
    my_if input_if(clk, rst_n);
    my_if output_if(clk, rst_n);
    
    dut my_dut(
        .clk(clk),
        .rst_n(rst_n),
        .rxd(input_if.data),
        .rx_dv(input_if.valid),
        .txd(output_if.data),
        .tx_en(output_if.valid)
    );
    initial begin
        uvm_config_db#(virtual my_if)::set(null, "uvm_test_top", "vif", input_if);
    end
    initial begin
        run_test("my_driver");
    end

    initial begin
        clk = 0;
        forever begin
            #100 clk = ~clk;
        end    
    end

    initial begin
        rst_n = 0;
        #1000;
        rst_n = 1;
    end
    // 运行verdi需要加下面的代码
    initial begin
        $fsdbDumpfile("tb.fsdb"); // To generate a file named tb.fsdb
        $fsdbDumpvars; // 记录当前模块及子模块的信号
        // $fsdbDumpvars(0, top_tb); // 记录top_tb及子模块信号
    end
endmodule