module UART_tb;

logic clk, reset;
logic [14:0] uart_control;
logic tx_fifo_wr, rx_fifo_rd;
logic [7:0] tx_fifo_data_in;
logic rx_in;
logic tx_out;
logic [7:0] rx_fifo_data_out;
logic [3:0] uart_status;

uart dut (.*);

// Clock Generation
always begin
    #5 clk = ~clk; // 10ns clock period
end


initial begin
    clk = 0;
    reset = 1;
    uart_control = 15'b101000000000100; // Loopback Enabled, One Stop bit, Even Parity, Baud Divisor = 4
    rx_fifo_rd = 1'b0;

    @(posedge clk);
        reset = 1'b0;

    // Load data in Tx FIFO 
    // Which will be transmitted by Tx and then received by Rx    
    @(posedge clk);
        tx_fifo_data_in = 8'h12;
        tx_fifo_wr = 1'b1;
    @(posedge clk);
        tx_fifo_wr = 1'b0;
    #300
    @(posedge clk);
        tx_fifo_data_in = 8'h34;
        tx_fifo_wr = 1'b1;
    @(posedge clk);
        tx_fifo_wr = 1'b0;
    #300
    @(posedge clk);
        tx_fifo_data_in = 8'h56;
        tx_fifo_wr = 1'b1;
    @(posedge clk);
        tx_fifo_wr = 1'b0;
    #300
    @(posedge clk);
        tx_fifo_data_in = 8'h78;
        tx_fifo_wr = 1'b1;
    @(posedge clk);
        tx_fifo_wr = 1'b0;

    #10
    // Read the data in Rx FIFO by processor
    @(posedge clk);
        rx_fifo_rd = 1'b1;
    @(posedge clk);
        rx_fifo_rd = 1'b0;

    #300
    @(posedge clk);
        tx_fifo_data_in = 8'h9a;
        tx_fifo_wr = 1'b1;
    @(posedge clk);
        tx_fifo_wr = 1'b0;
    #300
    @(posedge clk);
        tx_fifo_data_in = 8'hbc;
        tx_fifo_wr = 1'b1;
    @(posedge clk);
        tx_fifo_wr = 1'b0;
    #300
    @(posedge clk);
        tx_fifo_data_in = 8'hde;
        tx_fifo_wr = 1'b1;
    @(posedge clk);
        tx_fifo_wr = 1'b0;
    #300
    @(posedge clk);
        tx_fifo_data_in = 8'hf1;
        tx_fifo_wr = 1'b1;
    @(posedge clk);
        tx_fifo_wr = 1'b0;
    #300
    @(posedge clk);
        tx_fifo_data_in = 8'h23;
        tx_fifo_wr = 1'b1;
    @(posedge clk);
        tx_fifo_wr = 1'b0;

    #5000;
    $finish;
end

endmodule