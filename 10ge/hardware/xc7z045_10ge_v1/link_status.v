`timescale 1ns / 1ps

module link_status #
(
    parameter integer PIN_NUM = 0
)
(  
  input  wire [7:0] status_i,
  output wire link_o
);

  assign link_o = status_i[PIN_NUM];
  
endmodule
