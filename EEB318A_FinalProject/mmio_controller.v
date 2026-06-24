module mmio_controller (
    input wire clk,
    input wire rst,
    input wire [31:0] cpu_addr,
    input wire [31:0] cpu_wdata,
    input wire cpu_we,
    input wire cpu_re,
    output reg [31:0] cpu_rdata,
    input wire [1:0] sw_in,
    input wire btnc_in,
    input wire btnu_in,
    output wire [15:0] seg7_data,
    output wire [15:0] led_out
);
    reg [15:0] reg_seg7;
    reg [15:0] reg_led;
    reg [31:0] reg_timer; 

    assign seg7_data = reg_seg7;
    assign led_out = reg_led;

    always @(posedge clk or posedge rst) begin
        if (rst) reg_timer <= 0;
        else reg_timer <= reg_timer + 1;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            reg_seg7 <= 16'd0;
            reg_led <= 16'd0;
        end else if (cpu_we) begin
            case (cpu_addr)
                32'h4008: reg_seg7 <= cpu_wdata[15:0];
                32'h400C: reg_led  <= cpu_wdata[15:0];
            endcase
        end
    end

    always @(*) begin
        cpu_rdata = 32'd0;
        if (cpu_re) begin
            case (cpu_addr)
                32'h4000: cpu_rdata = {30'd0, sw_in};
                32'h4004: cpu_rdata = {30'd0, btnu_in, btnc_in};
                32'h4008: cpu_rdata = {16'd0, reg_seg7};
                32'h400C: cpu_rdata = {16'd0, reg_led};
                32'h4010: cpu_rdata = reg_timer; 
                default:  cpu_rdata = 32'd0;
            endcase
        end
    end
endmodule