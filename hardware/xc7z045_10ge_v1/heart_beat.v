/*----------------------------------------------------------------------------------------------------
 * engineer:        Artyom Shimko (soikadigital@gmail.com)
 *
 * created:         14.11.20  
 *
 * device:          cross-platform
 *
 * description:     It just heart beats due to input clk.
 *
 * dependencies:    non
 *
 * doc:             non
 *
 * rtl:             heart_beat.v
 *
 * tb:              heart_beat_tb.v
 *
 * version:         1.0
 *
 * revisions:       14.11.20    - There was createde the base vertion file;      
 */

 /* 
  heart_beat #
  (
    .CLK_VALUE   (),
    .SPEED_GRADE ()
  )
  heart_beat_inst0
  (
    .clk_i        (),
    
    .srst_n_i     (),
    .heart_beat_o ()
  );
 */

`timescale 1ns / 10ps

module heart_beat #
(
    parameter CLK_VALUE   = 100000000,
    parameter SPEED_GRADE = 2
)
(
    input  wire clk_i,
    input  wire srst_n_i,
  
    output wire heart_beat_o
);

    localparam integer COUNTER_WIDTH = $clog2(CLK_VALUE / SPEED_GRADE);
 
    reg                        heart_beat;
    reg [COUNTER_WIDTH - 1: 0] counter;
 
    assign heart_beat_o = heart_beat;
 
    always @ (posedge clk_i) begin
        if (1'h0 == srst_n_i) begin
            counter    <= {COUNTER_WIDTH {1'h0}};
            heart_beat <= 1'h0;
        end
        else begin
            if ({COUNTER_WIDTH {1'h0}} == counter) begin
                heart_beat <= ~heart_beat;
            end
            
            counter <= counter + 1'h1;
        end
    end
endmodule
