module pipeline_uart_tb;

logic clk;
logic reset;
logic uart_rx;
logic uart_tx;

// Instantiate the Processor
datapath dut (.*);

// Clock Generation
always begin
    #5 clk = ~clk; // 10ns clock period
end


// Testbench
initial begin
    // Initialize signals
    clk = 0;
    reset = 1;
    uart_rx = 1;
    @(posedge clk);
    #1;
    reset = 0;

    // Set sp to the top of the Stack
    dut.reg_file_0.registers[2] = 11'h3FC;

    // Instruction Memory
    dut.inst_mem_0.memory[0] =  32'hfc010113;
    dut.inst_mem_0.memory[1] =  32'h02812e23;
    dut.inst_mem_0.memory[2] =  32'h04010413;
    dut.inst_mem_0.memory[3] =  32'h01200793;
    dut.inst_mem_0.memory[4] =  32'hfcf42023;
    dut.inst_mem_0.memory[5] =  32'h03400793;
    dut.inst_mem_0.memory[6] =  32'hfcf42223;
    dut.inst_mem_0.memory[7] =  32'h05600793;
    dut.inst_mem_0.memory[8] =  32'hfcf42423;
    dut.inst_mem_0.memory[9] =  32'h07800793;
    dut.inst_mem_0.memory[10] = 32'hfcf42623;
    dut.inst_mem_0.memory[11] = 32'h09a00793;
    dut.inst_mem_0.memory[12] = 32'hfcf42823;
    dut.inst_mem_0.memory[13] = 32'h0bc00793;
    dut.inst_mem_0.memory[14] = 32'hfcf42a23;
    dut.inst_mem_0.memory[15] = 32'h0de00793;
    dut.inst_mem_0.memory[16] = 32'hfcf42c23;
    dut.inst_mem_0.memory[17] = 32'h0f100793;
    dut.inst_mem_0.memory[18] = 32'hfcf42e23;
    dut.inst_mem_0.memory[19] = 32'h02300793;
    dut.inst_mem_0.memory[20] = 32'hfef42023;
    dut.inst_mem_0.memory[21] = 32'h3fe00793;
    dut.inst_mem_0.memory[22] = 32'h00005737;
    dut.inst_mem_0.memory[23] = 32'h00470713;
    dut.inst_mem_0.memory[24] = 32'h00e7a023;
    dut.inst_mem_0.memory[25] = 32'hfe042623;
    dut.inst_mem_0.memory[26] = 32'h0400006f;
    dut.inst_mem_0.memory[27] = 32'h00000013;
    dut.inst_mem_0.memory[28] = 32'h3ff00793;
    dut.inst_mem_0.memory[29] = 32'h0007a783;
    dut.inst_mem_0.memory[30] = 32'h0087f793;
    dut.inst_mem_0.memory[31] = 32'hfe079ae3;
    dut.inst_mem_0.memory[32] = 32'h3fc00713;
    dut.inst_mem_0.memory[33] = 32'hfec42783;
    dut.inst_mem_0.memory[34] = 32'h00279793;
    dut.inst_mem_0.memory[35] = 32'hff078793;
    dut.inst_mem_0.memory[36] = 32'h008787b3;
    dut.inst_mem_0.memory[37] = 32'hfd07a783;
    dut.inst_mem_0.memory[38] = 32'h00f72023;
    dut.inst_mem_0.memory[39] = 32'hfec42783;
    dut.inst_mem_0.memory[40] = 32'h00178793;
    dut.inst_mem_0.memory[41] = 32'hfef42623;
    dut.inst_mem_0.memory[42] = 32'hfec42703;
    dut.inst_mem_0.memory[43] = 32'h00800793;
    dut.inst_mem_0.memory[44] = 32'hfae7dee3;
    dut.inst_mem_0.memory[45] = 32'hfe042423;
    dut.inst_mem_0.memory[46] = 32'h0100006f;
    dut.inst_mem_0.memory[47] = 32'hfe842783;
    dut.inst_mem_0.memory[48] = 32'h00178793;
    dut.inst_mem_0.memory[49] = 32'hfef42423;
    dut.inst_mem_0.memory[50] = 32'hfe842703;
    dut.inst_mem_0.memory[51] = 32'h06300793;
    dut.inst_mem_0.memory[52] = 32'hfee7d6e3;
    dut.inst_mem_0.memory[53] = 32'h00000013;
    dut.inst_mem_0.memory[54] = 32'h3ff00793;
    dut.inst_mem_0.memory[55] = 32'h0007a783;
    dut.inst_mem_0.memory[56] = 32'h0017f793;
    dut.inst_mem_0.memory[57] = 32'hfe079ae3;
    dut.inst_mem_0.memory[58] = 32'h3fd00793;
    dut.inst_mem_0.memory[59] = 32'h0007a783;
    dut.inst_mem_0.memory[60] = 32'hfef42223;
    dut.inst_mem_0.memory[61] = 32'h00000013;
    dut.inst_mem_0.memory[62] = 32'h3ff00793;
    dut.inst_mem_0.memory[63] = 32'h0007a783;
    dut.inst_mem_0.memory[64] = 32'h0087f793;
    dut.inst_mem_0.memory[65] = 32'hfe079ae3;
    dut.inst_mem_0.memory[66] = 32'h3fc00793;
    dut.inst_mem_0.memory[67] = 32'h04500713;
    dut.inst_mem_0.memory[68] = 32'h00e7a023;
    dut.inst_mem_0.memory[69] = 32'h0000006f;


    // Run simulation for a set period of time
    #15000;
    $finish;
end

endmodule