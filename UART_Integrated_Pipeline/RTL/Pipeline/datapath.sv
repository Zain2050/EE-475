module datapath(
    input logic clk, reset,
    input uart_rx,
    output uart_tx
);
    logic [31:0] pc_f, pc_e, pc_w, next_pc, extended_imm;
    logic [31:0] instruction_f, instruction_f_dff, instruction_e, instruction_w, alu_result_e, alu_result_w, rdata, wdata, wdata_dm;
    logic [31:0] rdata1_reg, rdata2_reg, rdata1, rdata2;
    logic [4:0] rs1, rs2, rd;
    logic [6:0] opcode;
    logic [3:0] alu_ctrl;
    logic [2:0] br_type;
    logic [1:0] wb_sel, wb_sel_w;
    logic reg_wr, rd_en, wr_en, br_taken, sel_A, sel_B;
    logic reg_wr_w, rd_en_w, wr_en_w, fwd_A, fwd_B, flush;

    logic [14:0] uart_control;
    logic [3:0] uart_status;
    logic tx_fifo_wr, rx_fifo_rd, rx_in, tx_out;
    logic [7:0] tx_fifo_data_in;
    logic [7:0] rx_fifo_data_out;

    //-----------------------------------------FETCH--------------------------------------------//

    pc pc_0 (clk, reset, next_pc, pc_f);
    inst_mem inst_mem_0 (pc_f, instruction_f_dff);

    //------------------------------------------------------------------------------------------//

    dff dff_00 (clk, reset, pc_f, pc_e);
    dff dff_01 (clk, reset, instruction_f, instruction_e);
    assign instruction_f = flush ? 32'h00000013 : instruction_f_dff;

    //-------------------------------------DECODE & EXECUTE-------------------------------------//

    reg_file reg_file_0 (clk, reset, reg_wr_w, rs1, rs2, instruction_w[11:7], wdata, rdata1_reg, rdata2_reg);
    imd_generator imd_generator_0 (instruction_e, extended_imm);
    assign rdata1 = fwd_A ? wdata : rdata1_reg;
    assign rdata2 = fwd_B ? wdata : rdata2_reg;
    alu alu_0 (alu_ctrl, sel_A ? rdata1 : pc_e, sel_B ? extended_imm : rdata2, alu_result_e);
    branch_cond branch_cond_0 (br_type, rdata1, rdata2, br_taken);
    control_unit control_unit_0 (instruction_e, reg_wr, rd_en, wr_en, sel_A, sel_B, wb_sel, alu_ctrl, br_type);
    forwarding_unit fwd_unit_0 (instruction_e, instruction_w, reg_wr_w, fwd_A, fwd_B);

    //------------------------------------------------------------------------------------------//

    dff dff_10 (clk, reset, pc_e, pc_w);
    dff dff_11 (clk, reset, alu_result_e, alu_result_w);
    dff dff_12 (clk, reset, rdata2, wdata_dm);
    dff dff_13 (clk, reset, instruction_e, instruction_w);
    control_unit_dff control_unit_1 (clk, reset, reg_wr, wr_en, rd_en, wb_sel, reg_wr_w, wr_en_w, rd_en_w, wb_sel_w);

    //------------------------------------MEMORY & WRITEBACK------------------------------------//
    
    uart uart_0(clk, reset, uart_control, tx_fifo_wr, rx_fifo_rd, tx_fifo_data_in, uart_rx, uart_tx, rx_fifo_data_out, uart_status);
    lsu lsu_0 (clk, wr_en_w, rd_en_w, alu_result_w, wdata_dm, rdata, uart_control, tx_fifo_wr, rx_fifo_rd, tx_fifo_data_in, rx_fifo_data_out, uart_status);

    always_comb begin
         case (wb_sel_w)
            2'b00: wdata = pc_w + 4;
            2'b01: wdata = alu_result_w;
            2'b10: wdata = rdata;
        endcase
    end

    //-----------------------------------------------------------------------------------------//
   
    
    assign opcode = instruction_e[6:0];
    assign rs1 = instruction_e[19:15];
    assign rs2 = instruction_e[24:20];
    assign rd = instruction_w[11:7];
    assign next_pc = br_taken ? alu_result_e : pc_f + 4;
    assign flush = br_taken ? 1'b1 : 1'b0;

endmodule
