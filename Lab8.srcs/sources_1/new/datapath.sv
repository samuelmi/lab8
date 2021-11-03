`timescale 1ns / 1ps
`default_nettype none
module datapath #(parameter Dbits=32, parameter Nreq=32
)(
    input wire clk,
    input wire reset,
    input wire enable,
    
    input wire [Dbits-1:0] instr,
    input wire [1:0] pcsel,
    input wire [1:0] wasel,
    input wire sgnext,
    input wire bsel,
    input wire [1:0] wdsel,
    input wire [4:0] alufn,
    input wire werf,
    input wire [1:0] asel,
    input wire [Dbits-1:0] mem_readdata,
    
    output wire Z,
    output wire [Dbits-1:0] mem_addr,
    output wire [Dbits-1:0] mem_writedata,
    output wire [Dbits-1:0] pc
    
    );
    
    wire [$clog2(Nreq)-1:0] rd1_address; // Address if A register
    wire [$clog2(Nreq)-1:0] rd2_address; // Address if B register
    wire [$clog2(Nreq)-1:0] wr_address; // Address of destination register
    
    wire [Dbits-1:0] rd1_out; // Output from rd1
    wire [Dbits-1:0] rd2_out; // Output from rd2
    wire [Dbits-1:0] wr_in;   // Input into register
    
    wire [Dbits-1:0] aluA; // Input A into ALU
    wire [Dbits-1:0] aluB; // Input B into ALU
    
    wire [Dbits-1:0] alu_result; // Output from ALU
    
    wire [Dbits-1:0] sgnext_out; // Output from SgnExt
    
    assign mem_addr = alu_result;
    assign mem_writedata = rd2_out;
    
    assign rd1_address = instr[25:21];
    assign rd2_address = instr[20:16];
    
    // WASEL MUX
    assign wr_address = (wasel == 2'b00) ? instr[15:11] // Rd
                      : (wasel == 2'b01) ? instr[20:16] // Rt
                      : (wasel == 2'b10) ? 5'b11111     // 31
                      : 5'bxxxxx;
    
    // BSEL MUX
    assign aluB = (bsel == 1'b0) ? rd2_out
                : sgnext_out;
    
    // WDSEL MUX
    assign wr_in = (wdsel == 2'b00) ? pc + 4
                 : (wdsel == 2'b01) ? alu_result
                 : (wdsel == 2'b10) ? mem_readdata
                 : {(Dbits){1'bx}};
    
    // ASEL MUX
    assign aluA = (asel == 2'b00) ? rd1_out
                : (asel == 2'b01) ? instr[10:6]
                : (asel == 2'b10) ? 5'b10000
                : {(Dbits){1'bx}};
    
    // Sign Extension and SgnExt MUX
    sign_extend se(
        .unsigned_val(instr[15:0]),
        .enable(sgnext),
        .signed_val(sgnext_out));
    
    // Program Counter and PCSEL MUX
    logic [Dbits-1:0] count = 32'h0040_0000;
    always_ff @(posedge clk) begin
        count <= reset ? 32'h0040_0000         // If reset == 1, count = 0
               : enable ?
                    (pcsel == 2'b00) ? count + 4
                  : (pcsel == 2'b01) ? (count + 4) + (sgnext_out << 2)
                  : (pcsel == 2'b10) ? {count[31:28], instr[25:0], 2'b00}
                  : rd1_out
               : count;                 // If enable == 0, hold count at current value
    end 
    assign pc = count;

    // Creates register file for ALU and WERF MUX
    register_file #(.Nloc(Nreq), .Dbits(Dbits)) rf(
     .clock(clk), 
     .wr(werf), 
     .ReadAddr1(rd1_address),
     .ReadAddr2(rd2_address),
     .WriteAddr(wr_address),
     .ReadData1(rd1_out),
     .ReadData2(rd2_out),
     .WriteData(wr_in)
    );
    
    // Creates ALU
    ALU #(Dbits) alu(.A(aluA), .B(aluB), .R(alu_result), .ALUfn(alufn), .FlagZ(Z));
    
    
    
endmodule
