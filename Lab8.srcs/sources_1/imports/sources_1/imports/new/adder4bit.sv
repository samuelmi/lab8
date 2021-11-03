`default_nettype none
module adder4bit(
    input wire [3:0] A,
    input wire [3:0] B,
    input wire Cin,
    output wire [3:0] Sum,
    output wire Cout
    );
    
    wire C1, C2, C3;
    fulladder a0(A[0], B[0], Cin, Sum[0], C1);
    fulladder a2(A[1], B[1], C1, Sum[1], C2);
    fulladder a3(A[2], B[2], C2, Sum[2], C3);
    fulladder a4(A[3], B[3], C3, Sum[3], Cout);
endmodule
