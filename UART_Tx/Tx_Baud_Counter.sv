module Tx_Baud_Counter (
    input logic clk, reset,
    input logic [11:0] baud_div,
    output logic baud_comp
);
    
    logic [11:0] counter;

    always @(posedge clk) begin
        if (reset || baud_comp) begin
            baud_comp <= 1'b0;
            counter <= 12'b0;
        end
        else if (counter == baud_div)
            baud_comp <= 1'b1;
        else begin
            baud_comp <= 1'b0;
            counter <= counter + 1;
        end
    end

endmodule