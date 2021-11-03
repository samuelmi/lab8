//////////////////////////////////////////////////////////////////////////////////
//
// Montek Singh
// 10/1/2021
//
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
`default_nettype none

//////////////////////////////////////////////////////////////////////////////////
//
// NOTE:  There should be NO NEED TO MODIFY *ANYTHING* in this template.
//        You do NOT need to modify any parameters at the top, nor any of
//        the bit widths of address or data.
//
//        Simply specify different values for the parameters inside the parent
//        when the ram module is instantiated.
//
//        Modifying anything here is cause for much headache later on!
//////////////////////////////////////////////////////////////////////////////////




// DO NOT MODIFY *ANYTHING* BELOW!!!!!!!!!!!!!!!!
// DO NOT MODIFY *ANYTHING* BELOW!!!!!!!!!!!!!!!!
// DO NOT MODIFY *ANYTHING* BELOW!!!!!!!!!!!!!!!!
// DO NOT MODIFY *ANYTHING* BELOW!!!!!!!!!!!!!!!!
// DO NOT MODIFY *ANYTHING* BELOW!!!!!!!!!!!!!!!!
// DO NOT MODIFY *ANYTHING* BELOW!!!!!!!!!!!!!!!!


module ram_module #(
   parameter Nloc = 16,                      // Number of memory locations
   parameter Dbits = 4,                      // Number of bits in data
   parameter initfile = "noname.mem"         // Name of file with initial values (file should not exist)
)(
   input wire clock,
   input wire wr,                            // WriteEnable:  if wr==1, data is written into mem
   input wire [$clog2(Nloc)-1 : 0] addr,     // Address for specifying memory location
                                             //   num of bits in addr is ceiling(log2(number of locations))
   input wire [Dbits-1 : 0] din,             // Data for writing into memory (if wr==1)
   output wire [Dbits-1 : 0] dout            // Data read from memory (asynchronously, i.e., continuously)
   );

   logic [Dbits-1 : 0] mem [Nloc-1 : 0];     // The actual storage where data resides
   initial $readmemh(initfile, mem, 0, Nloc-1); // Initialize memory contents from a file

   always_ff @(posedge clock)                // Memory write: only when wr==1, and only at posedge clock
      if(wr)
         mem[addr] <= din;

   assign dout = mem[addr];                  // Memory read: read continuously, no clock involved

endmodule
