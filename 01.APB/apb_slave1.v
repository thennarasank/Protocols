`timescale 1ns/1ps

module apb_slave1(
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

  logic [31:0] mem [0:15];
  integer i;

  assign PREADY = 1'b1;

  always_ff @(posedge PCLK or negedge PRESETn) begin
    if (!PRESETn) begin
      PRDATA <= 32'd0;
      for (i = 0; i < 16; i = i + 1)
        mem[i] <= 32'd0;
    end
    
    else if (PSEL && PENABLE && PREADY) begin
      if (PWRITE)
        mem[PADDR[3:0]] <= PWDATA;
      else
        PRDATA <= mem[PADDR[3:0]];
    end
  end

endmodule
