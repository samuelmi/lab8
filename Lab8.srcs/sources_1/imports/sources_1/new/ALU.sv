`default_nettype none
module ALU #(parameter N=32) (
    input wire [N-1:0] A, B,
    output wire [N-1:0] R,
    input wire [4:0] ALUfn,
    output wire FlagZ
    );
    
    wire subtract, bool1, bool0, shft, math;
    wire FlagN, FlagC, FlagV;
    assign {subtract, bool1, bool0, shft, math} = ALUfn[4:0];
    
    wire [N-1:0] addsubResult, shiftResult, logicalResult;
    wire compResult;
    
    addsub #(N) AS(A, B, subtract, addsubResult, FlagN, FlagC, FlagV);
    shifter #(N) S(B, A[$clog2(N)-1:0], ~bool1, ~bool0, shiftResult);
    logical #(N) L(A, B, {bool1, bool0}, logicalResult); 
    comparator C(FlagN, FlagV, FlagC, bool0, compResult);
    
    assign R = (~shft & math) ? addsubResult :
               (shft & ~math) ? shiftResult :
               (~shft & ~math) ? logicalResult : 
               (shft & math) ? {{(N-1){1'b0}}, compResult} : 1'bx;
               
    assign FlagZ = ~|R;
    
endmodule
