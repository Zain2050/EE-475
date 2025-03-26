module Rx_Baud_Counter (
    input logic clk, reset,
    input logic [11:0] baud_div,
    input logic rx_start,
    output logic baud_comp
);
    
    logic [11:0] counter;

    always @(posedge clk) begin
        if (reset)
            counter <= 12'b1;
        else if (rx_start)
            // Half of Baud Divisor + 2 (latency) cycles
            counter <= (baud_div >> 1) + 2; 
        else if (baud_comp)
            counter <= 12'b1;
        else
            counter <= counter + 1;
    end

    assign baud_comp = (counter == baud_div) ? 1'b1 : 1'b0;

endmodule