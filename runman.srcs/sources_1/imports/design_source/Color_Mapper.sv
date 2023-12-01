//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Zuofu Cheng   08-19-2023                               --
//                                                                       --
//    Fall 2023 Distribution                                             --
//                                                                       --
//    For use with ECE 385 USB + HDMI                                    --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------


module  color_mapper ( input  logic [9:0]  DrawX, DrawY, song_progress, 
                       output logic [3:0]  Red, Green, Blue );
    
    logic progress_bar;
    logic progress;
	 
 /* Old Ball: Generated square box by checking if the current pixel is within a square of length
    2*BallS, centered at (BallX, BallY).  Note that this requires unsigned comparisons.
	 
    if ((DrawX >= BallX - Ball_size) &&
       (DrawX <= BallX + Ball_size) &&
       (DrawY >= BallY - Ball_size) &&
       (DrawY <= BallY + Ball_size))
       )

     New Ball: Generates (pixelated) circle by using the standard circle formula.  Note that while 
     this single line is quite powerful descriptively, it causes the synthesis tool to use up three
     of the 120 available multipliers on the chip!  Since the multiplicants are required to be signed,
	  we have to first cast them from logic to int (signed by default) before they are multiplied). */
	  
//    int DistX, DistY, Size;
//    assign DistX = DrawX - BallX;
//    assign DistY = DrawY - BallY;
//    assign Size = Ball_size;
  
//    always_comb
//    begin:Ball_on_proc
//        if ( (DistX*DistX + DistY*DistY) <= (Size * Size) )
//            progress_bar = 1'b1;
//        else 
//            progress_bar = 1'b0;
//     end 
     
    always_comb
    begin:Progress_bar
        if ( DrawX <= 575 && 65 <= DrawX && DrawY <= 400 &&  375 <= DrawY )
            progress_bar = 1'b1;
        else 
            progress_bar = 1'b0;
     end 
     
     
    always_comb
    begin:Progress
        if ( DrawX <= song_progress + 70 && 70 <= DrawX && DrawY <= 395 &&  380 <= DrawY )
            progress = 1'b1;
        else 
            progress = 1'b0;
     end 
     
     
//     logic test;
//    always_comb
//    begin:Test
//        if ( DrawY <= 100 )
//            test = 1'b1;
//        else 
//            test = 1'b0;
//     end 
     
//    always_comb
//    begin:Progress
//        if ( 200 <=  DrawY)
//            progress = 1'b1;
//        else 
//            progress = 1'b0;
//     end 
       
    always_comb
    begin:RGB_Display
        
        if ((progress == 1'b1)) begin 
            Red = 4'h0;
            Green = 4'h7;
            Blue = 4'h0;
        end  
        else if ((progress_bar == 1'b1)) begin 
            Red = 4'hf;
            Green = 4'h7;
            Blue = 4'h0;
        end
//        else if ((test == 1'b1)) begin 
//            Red = 4'h0;
//            Green = 4'h0;
//            Blue = 4'hF;
//        end        
        else begin 
            Red = 4'hf - DrawX[9:6]; 
            Green = 4'hf - DrawX[9:6];
            Blue = 4'hf - DrawX[9:6];
        end      
    end 
    
endmodule
