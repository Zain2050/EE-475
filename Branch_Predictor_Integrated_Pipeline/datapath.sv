// Author : Muhammad Zain
// Date   : 27/4/2025

module datapath(
    input logic clk, reset
);
    logic [31:0] pc_f, pc_e, pc_w, next_pc, extended_imm_f, extended_imm_e;
    logic [31:0] instruction_f, instruction_e, instruction_w, alu_result_e, alu_result_w, rdata, wdata, wdata_dm;
    logic [31:0] rdata1_f, rdata2_f, rdata1_e, rdata2_e, rdata1, rdata2;
    logic [4:0] rs1, rs2, rd;
    logic [3:0] alu_ctrl;
    logic [2:0] br_type;
    logic [1:0] wb_sel, wb_sel_w;
    logic reg_wr, rd_en, wr_en, br_taken, sel_A, sel_B;
    logic reg_wr_w, rd_en_w, wr_en_w, fwd_A, fwd_B, flush;
    logic [1:0] br_state_e, br_state_f;
    logic prediction_made_f, prediction_made_e;
    logic jalr_addr_req_f, jalr_addr_req_e, prediction_correct;



    //-------------------------------------FETCH & DECODE---------------------------------------//

    pc pc_0 (clk, reset, next_pc, pc_f);
    inst_mem inst_mem_0 (pc_f, instruction_f);

    reg_file reg_file_0 (clk, reset, reg_wr_w, rs1, rs2, rd, wdata, rdata1_f, rdata2_f);
    imd_generator imd_generator_0 (instruction_f, extended_imm_f);

    assign rs1 = instruction_f[19:15];
    assign rs2 = instruction_f[24:20];
    assign rd = instruction_w[11:7];

    branch_predictor branch_predictor_0 (clk, reset, pc_f, instruction_f, extended_imm_f, pc_e, alu_result_e, 
    br_state_e, prediction_made_e, jalr_addr_req_e, br_taken, prediction_correct, br_state_f, prediction_made_f, jalr_addr_req_f, next_pc);

    //------------------------------------------------------------------------------------------//

    dff_32b dff_00 (clk, reset, pc_f, pc_e);
    dff_32b dff_01 (clk, reset, (flush ? 32'b0 : rdata1_f), rdata1_e);
    dff_32b dff_02 (clk, reset, (flush ? 32'b0 : rdata2_f), rdata2_e);
    dff_32b dff_03 (clk, reset, (flush ? 32'b0 : extended_imm_f), extended_imm_e);
    dff_32b dff_04 (clk, reset, (flush ? 32'h00000013 : instruction_f), instruction_e);
    dff_2b  dff_05 (clk, reset, br_state_f, br_state_e);
    dff_1b  dff_06 (clk, reset, prediction_made_f, prediction_made_e);
    dff_1b  dff_07 (clk, reset, jalr_addr_req_f, jalr_addr_req_e);

    //----------------------------------------EXECUTE-------------------------------------------//

    assign rdata1 = fwd_A ? wdata : rdata1_e;
    assign rdata2 = fwd_B ? wdata : rdata2_e;
    alu alu_0 (alu_ctrl, sel_A ? rdata1 : pc_e, sel_B ? extended_imm_e : rdata2, alu_result_e);
    branch_cond branch_cond_0 (br_type, rdata1, rdata2, br_taken);
    control_unit control_unit_0 (instruction_e, br_state_e[1], br_taken, jalr_addr_req_e, reg_wr, rd_en, wr_en, sel_A, sel_B, 
    wb_sel, alu_ctrl, br_type, prediction_correct, flush);
    forwarding_unit fwd_unit_0 (instruction_e, instruction_w, reg_wr_w, fwd_A, fwd_B);

    //------------------------------------------------------------------------------------------//

    dff_32b dff_10 (clk, reset, pc_e, pc_w);
    dff_32b dff_11 (clk, reset, alu_result_e, alu_result_w);
    dff_32b dff_12 (clk, reset, rdata2, wdata_dm);
    dff_32b dff_13 (clk, reset, instruction_e, instruction_w);
    control_unit_dff control_unit_1 (clk, reset, reg_wr, wr_en, rd_en, wb_sel, reg_wr_w, wr_en_w, rd_en_w, wb_sel_w);

    //------------------------------------MEMORY & WRITEBACK------------------------------------//

    data_mem data_mem_0 (clk, wr_en_w, rd_en_w, alu_result_w, wdata_dm, rdata);
    always_comb begin
         case (wb_sel_w)
            2'b00: wdata = pc_w + 4;
            2'b01: wdata = alu_result_w;
            2'b10: wdata = rdata;
        endcase
    end

    //-----------------------------------------------------------------------------------------//


endmodule
