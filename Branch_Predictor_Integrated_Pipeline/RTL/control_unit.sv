module control_unit (
    input logic [31:0] inst,
    input logic br_prediction, br_actual, jalr_addr_req,
    output logic reg_wr, rd_en, wr_en, sel_A, sel_B,
    output logic [1:0] wb_sel,
    output logic [3:0] alu_op,
    output logic [2:0] br_type,
    output logic prediction_correct, flush
);
    logic [4:0] rs1, rs2, rd;
    logic [6:0] opcode, func7;
    logic [2:0] func3;

    assign opcode = inst[6:0];
    assign rd = inst[11:7];
    assign func3 = inst[14:12];
    assign rs1 = inst[19:15];
    assign rs2 = inst[24:20];
    assign func7 = inst[31:25];


    always_comb begin

        // R-Type
        if (opcode == 7'b0110011) begin
            reg_wr = 1;
            rd_en = 0;
            wr_en = 0;
            sel_A = 1;
            sel_B = 0;
            wb_sel = 2'b01;
            br_type = 3'b000;
            flush = 1'b0;

            if (func3 == 3'b000 && func7 == 7'b0000000) // ADD
                alu_op = 4'b0000;
            else if (func3 == 3'b000 && func7 == 7'b0100000) // SUB
                alu_op = 4'b0001;
            else if (func3 == 3'b001 && func7 == 7'b0000000) // SLL
                alu_op = 4'b0010;
            else if (func3 == 3'b101 && func7 == 7'b0000000) // SRL
                alu_op = 4'b0011;
            else if (func3 == 3'b101 && func7 == 7'b0100000) // SRA
                alu_op = 4'b0100;
            else if (func3 == 3'b010 && func7 == 7'b0000000) // SLT
                alu_op = 4'b0101;
            else if (func3 == 3'b011 && func7 == 7'b0000000) // SLTU
                alu_op = 4'b0110;
            else if (func3 == 3'b100 && func7 == 7'b0000000) // XOR
                alu_op = 4'b0111;            
            else if (func3 == 3'b110 && func7 == 7'b0000000) // OR
                alu_op = 4'b1000;
            else if (func3 == 3'b111 && func7 == 7'b0000000) // AND
                alu_op = 4'b1001;
        end

        // I-Type
        else if (opcode == 7'b0010011) begin
            reg_wr = 1;
            rd_en = 0;
            wr_en = 0;
            sel_A = 1;
            sel_B = 1;
            wb_sel = 2'b01;
            br_type = 3'b000;
            flush = 1'b0;

            if (func3 == 3'b000) // ADDI
                alu_op = 4'b0000;
            else if (func3 == 3'b001) // SLLI
                alu_op = 4'b0010;
            else if (func3 == 3'b101 && func7 == 7'b0000000) //SRLI
                alu_op = 4'b0011;
            else if (func3 == 3'b101 && func7 == 7'b0100000) //SRAI
                alu_op = 4'b0100;
            else if (func3 == 3'b010) // SLTI
                alu_op = 4'b0101;
            else if (func3 == 3'b011) // SLTIU
                alu_op = 4'b0110;
            else if (func3 == 3'b100) // XOR
                alu_op = 4'b0111;
            else if (func3 == 3'b110) // OR
                alu_op = 4'b1000;
            else if (func3 == 3'b111) // AND
                alu_op = 4'b1001;
        end

        // I-Type (Load)
        else if (opcode == 7'b0000011) begin
            reg_wr = 1;
            rd_en = 1;
            wr_en = 0;
            sel_A = 1;
            sel_B = 1;
            wb_sel = 2'b10;
            br_type = 3'b000;
            alu_op = 4'b0000;
            flush = 1'b0;
        end

        // S-Type   
        else if (opcode == 7'b0100011) begin
            reg_wr = 0;
            rd_en = 0;
            wr_en = 1;
            sel_A = 1;
            sel_B = 1;
            wb_sel = 2'b01;
            br_type = 3'b000;
            alu_op = 4'b0000;
            flush = 1'b0;
        end

        // B-Type   
        else if (opcode == 7'b1100011) begin
            reg_wr = 0;
            rd_en = 0;
            wr_en = 0;
            sel_A = 0;
            sel_B = 1;
            wb_sel = 2'b01;
            alu_op = 4'b0000;

            if (func3 == 3'b000) // BEQ
                br_type = 3'b001;
            else if (func3 == 3'b001) // BNE
                br_type = 3'b010;
            else if (func3 == 3'b100) // BLT
                br_type = 3'b011;
            else if (func3 == 3'b101) // BGE
                br_type = 3'b100;
            else if (func3 == 3'b110) // BLTU
                br_type = 3'b101;
            else if (func3 == 3'b111) // BGEU
                br_type = 3'b110;

            // Check Prediction
            prediction_correct = (br_prediction == br_actual);
            if (~prediction_correct)
                flush = 1'b1;
            else
                flush = 1'b0;
        end

        // U-Type   
        else if (opcode == 7'b0110111) begin // LUI
            reg_wr = 1;
            rd_en = 0;
            wr_en = 0;
            sel_A = 0;
            sel_B = 1;
            wb_sel = 2'b01;
            br_type = 3'b000;
            alu_op = 4'b1010;
            flush = 1'b0;
        end
        else if (opcode == 7'b0010111) begin // AUIPC
            reg_wr = 1;
            rd_en = 0;
            wr_en = 0;
            sel_A = 0;
            sel_B = 1;
            wb_sel = 2'b01;
            br_type = 3'b000;
            alu_op = 4'b0000;
            flush = 1'b0;
        end

        // J-Type
        else if (opcode == 7'b1101111) begin // JAL
            reg_wr = 1;
            rd_en = 0;
            wr_en = 0;
            sel_A = 0;
            sel_B = 1;
            wb_sel = 2'b00;
            br_type = 3'b000;
            alu_op = 4'b0000;
            flush = 1'b0;
        end
        else if (opcode == 7'b1100111) begin // JALR
            reg_wr = 1;
            rd_en = 0;
            wr_en = 0;
            sel_A = 1;
            sel_B = 1;
            wb_sel = 2'b00;
            br_type = 3'b000;
            alu_op = 4'b0000;
            flush = jalr_addr_req;  // As we didn't had addr in fetch stage, therefore wrong inst is loaded
        end
        else
            flush = 1'b0;

    end
endmodule
