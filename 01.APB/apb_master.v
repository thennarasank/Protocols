`timescale 1ns/1ps

module master_apb(
  input logic PCLK,
  input logic PRESETn,
  input logic [31:0] PRDATA,
  input logic PREADY,
  output logic [7:0] PADDR,  
  output logic PWRITE,
  output logic [31:0] PWDATA,
  output logic PENABLE,
  output logic PSEL
);
  
  initial begin
    PADDR = 0;
    PWDATA = 0;
    PWRITE = 0;
    PENABLE = 0;
    PSEL = 0;
  end
  
  task apb_write(input [7:0] addr, input [31:0] data);
    @(posedge PCLK);
    PADDR <= {24'h0, addr};  
    PWDATA <= data;
    PWRITE <= 1;
    PSEL <= 1;
    PENABLE <= 0;
    
    @(posedge PCLK);
    PENABLE <= 1;
    
    wait(PREADY == 1);
    
    @(posedge PCLK);
    $display("| write data = %h | addr = %d | $time = %0t  ", PWDATA,PADDR,$time);
    PSEL <= 0;
    PENABLE <= 0;
    PWRITE <= 0;
  endtask
  
  task apb_read(input [7:0] addr);
    @(posedge PCLK);
    PADDR <= {24'h0, addr};   
    PSEL <= 1;
    PWRITE <= 0;
    PENABLE <= 0;
    
    @(posedge PCLK);
    PENABLE <= 1;
    
    wait(PREADY == 1);
    
    @(posedge PCLK);
    $display("|  read data = %h | addr = %d | $time = %0t  ",PRDATA,PADDR,$time);
    PENABLE <= 0;
    PSEL <= 0;
  endtask
  
  initial begin 
    @(posedge PRESETn);
    
    apb_write(8'h01, 32'h11223344);
    apb_read(8'h01);
    
    apb_write(8'h02, 32'h11112222);
    apb_read(8'h02);
    
    apb_write(8'h03, 32'h12233344);
    apb_read(8'h03);
    
    apb_write(8'h04, 32'h12344321);
    apb_read(8'h04);
    
    #11 $finish;
    
  end
  
endmodule
