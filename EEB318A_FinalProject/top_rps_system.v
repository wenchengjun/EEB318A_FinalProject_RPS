module top_rps_system (
    input wire clk,
    input wire rst_n,
    input wire [1:0] sw,
    input wire btnc,
    input wire btnu,
    output wire [3:0] an,
    output wire [6:0] seg,
    output wire [15:0] led
);
    wire rst = ~rst_n;
    wire btnc_clean, btnu_clean;
    
    debounce db_btnc (.clk(clk), .rst(rst), .btn_in(btnc), .btn_out(btnc_clean));
    debounce db_btnu (.clk(clk), .rst(rst), .btn_in(btnu), .btn_out(btnu_clean));

    wire [31:0] cpu_addr, cpu_wdata, cpu_rdata;
    wire cpu_we, cpu_re;
    wire [15:0] seg7_data;

    mmio_controller mmio_inst (
        .clk(clk), .rst(rst),
        .cpu_addr(cpu_addr), .cpu_wdata(cpu_wdata),
        .cpu_we(cpu_we), .cpu_re(cpu_re), .cpu_rdata(cpu_rdata),
        .sw_in(sw), .btnc_in(btnc_clean), .btnu_in(btnu_clean),
        .seg7_data(seg7_data), .led_out(led)
    );

    seg7_controller seg7_inst (
        .clk(clk), .rst(rst), .data_in(seg7_data),
        .an(an), .seg(seg)
    );

    // 請將 your_riscv_core 替換為實際使用的 RISC-V 模組
    /*
    your_riscv_core cpu_inst (
        .clk(clk), .rst(rst),
        .mem_addr(cpu_addr), .mem_wdata(cpu_wdata), .mem_rdata(cpu_rdata),
        .mem_we(cpu_we), .mem_re(cpu_re)
    );
    */
endmodule