module seg7_controller (
    input wire clk,
    input wire rst,
    input wire [15:0] data_in,
    output reg [3:0] an,
    output reg [6:0] seg
);
    reg [17:0] clkdiv;
    
    always @(posedge clk or posedge rst) begin
        if (rst) clkdiv <= 0;
        else clkdiv <= clkdiv + 1;
    end

    wire [1:0] scan_sel = clkdiv[17:16];
    reg [3:0] hex_val;

    always @(*) begin
        case (scan_sel)
            2'b00: begin an = 4'b1110; hex_val = data_in[3:0];   end 
            2'b01: begin an = 4'b1101; hex_val = data_in[7:4];   end 
            2'b10: begin an = 4'b1011; hex_val = data_in[11:8];  end 
            2'b11: begin an = 4'b0111; hex_val = data_in[15:12]; end 
        endcase
    end

    always @(*) begin
        case (hex_val)
            4'h0: seg = 7'b1000000;
            4'h1: seg = 7'b1111001;
            4'h2: seg = 7'b0100100;
            4'h3: seg = 7'b0110000;
            4'h4: seg = 7'b0011001;
            4'h5: seg = 7'b0010010;
            4'h6: seg = 7'b0000010;
            4'h7: seg = 7'b1111000;
            4'h8: seg = 7'b0000000;
            4'h9: seg = 7'b0010000;
            default: seg = 7'b1111111; 
        endcase
    end
endmodule