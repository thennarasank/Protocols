
`timescale 1ns/1ps

module apb_slave2(
  input logic PCLK,
  input logic PRESETn,
  input logic PSEL,
  input logic PWRITE,
  input logic PENABLE,
  input logic [7:0] PADDR,
  input logic [31:0] PWDATA,
  output logic [31:0] PRDATA,
  output logic PREADY
);

  logic [31:0] reg1;

  assign PREADY = 1'b1;

  always_ff @(posedge PCLK or negedge PRESETn) begin
    if (!PRESETn) begin
      reg1   <= 32'd0;
      PRDATA <= 32'd0;
    end
    
    else if (PSEL && PENABLE && PREADY) begin
      if (PWRITE)
        reg1 <= PWDATA;
      else
        PRDATA <= reg1;
    end
    
  end

endmodule
