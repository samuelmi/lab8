`timescale 1ns / 1ps
`default_nettype none

module sign_extend (
    input wire [15:0] unsigned_val,
    input wire enable,
    output wire [31:0] signed_val
    );
    
    wire [15:0] padding;
    assign padding = enable ? {16{unsigned_val[15]}}
                            : {16{1'b0}};
    
    assign signed_val = {padding, unsigned_val};
    
endmodule
