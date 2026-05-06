    module top
    (
        input  CLK, //FPGA's clocck

        output LCD_CLK,//LCD clock. 
        output LCD_DEN,
        output [4:0] LCD_R,
        output [5:0] LCD_G,
        output [4:0] LCD_B
    );


        //pixel updates left to right and then top to bottom 
        logic [9:0] x = 0; 
        logic [8:0] y = 0; 

        assign LCD_CLK = CLK; 

    always @ (posedge LCD_CLK) begin

        //check that we are within active region values 
        LCD_DEN <= ((x < 480) && (y < 272)); 

        //go left to right until reach end of line
        if (x < 524) begin
            x <= x + 1;
        end else if (x == 524) begin
            //go down a row 
            if (y < 284) begin
                y <= y + 1; 
            end else if (y == 284) begin
                y <= 0; 
            end 

            //reset x to leftmost
            x <= 0; 
        end
    end

    always @ (*) begin 
        //ignore pixel data
        if (!((x < 480) && (y < 272))) begin
            LCD_B = 5'd0; 
            LCD_G = 6'd0; 
            LCD_R = 5'd0; 
        end else begin
            //RED, GREEN, BLUE
            if (x < 160) begin 
                LCD_B = 5'd0; 
                LCD_G = 6'd0; 
                LCD_R = 5'd31; 
            end else if ( x < 320 ) begin
                LCD_B = 5'd0; 
                LCD_G = 6'd63; 
                LCD_R = 5'd0; 
            end else if (x < 480) begin
                LCD_B = 5'd31; 
                LCD_G = 6'd0; 
                LCD_R = 5'd0; 
            end
        end
    end
        
    endmodule
