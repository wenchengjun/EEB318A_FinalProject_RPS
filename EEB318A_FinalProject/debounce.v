module debounce (
    input wire clk,
    input wire rst,
    input wire btn_in,
    output reg btn_out
);
    reg [19:0] count;
    reg btn_sync_0, btn_sync_1;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            btn_sync_0 <= 0;
            btn_sync_1 <= 0;
            count <= 0;
            btn_out <= 0;
        end else begin
            btn_sync_0 <= btn_in;
            btn_sync_1 <= btn_sync_0;

            if (btn_sync_1 == btn_out) begin
                count <= 0;
            end else begin
                count <= count + 1;
                if (count == 20'd1_000_000) begin 
                    btn_out <= btn_sync_1;
                    count <= 0;
                end
            end
        end
    end
endmodule