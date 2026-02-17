
`include "Master.sv"
`include "slave1.sv"
`include "slave2.sv"

`timescale 1ns/1ps

module apb_design;

  logic PCLK;
  logic PRESETn;
  
  logic [31:0] PADDR_master;
  logic [31:0] PWDATA;
  logic PWRITE;
  logic PSEL_master;
  logic PENABLE;
  
  logic [7:0] PADDR_slave;
  logic PSEL1, PSEL2;
  
  logic [31:0] PRDATA1, PRDATA2;
  logic PREADY1, PREADY2;
  
  logic [31:0] PRDATA;
  logic PREADY;

  initial begin
    PCLK = 0;
    forever #5 PCLK = ~PCLK;
  end

  initial begin
    PRESETn = 0;
    #20 PRESETn = 1;
  end

  assign PADDR_slave = PADDR_master[7:0];

  always_comb begin
    PSEL1 = 0;
    PSEL2 = 0;
    if (PSEL_master) begin
      if (PADDR_master[7:4] == 4'h0) PSEL1 = 1;
      else if (PADDR_master[7:4] == 4'h1) PSEL2 = 1;
    end
  end

  always_comb begin
    if (PSEL1) begin
      PRDATA = PRDATA1;
      PREADY = PREADY1;
    end
    else if (PSEL2) begin
      PRDATA = PRDATA2;
      PREADY = PREADY2;
    end
    else begin
      PRDATA = 32'h0;
      PREADY = 1'b1;
    end
    
  end

  apb_slave1 u_slave1 (
    .PCLK(PCLK),
    .PRESETn(PRESETn),
    .PSEL(PSEL1),
    .PWRITE(PWRITE),
    .PENABLE(PENABLE),
    .PADDR(PADDR_slave),
    .PWDATA(PWDATA),
    .PRDATA(PRDATA1),
    .PREADY(PREADY1)
  );

  apb_slave2 u_slave2 (
    .PCLK(PCLK),
    .PRESETn(PRESETn),
    .PSEL(PSEL2),
    .PWRITE(PWRITE),
    .PENABLE(PENABLE),
    .PADDR(PADDR_slave),
    .PWDATA(PWDATA),
    .PRDATA(PRDATA2),
    .PREADY(PREADY2)
  );

endmodule
