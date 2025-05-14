module i2c_controller_tb (i2c_cont_if.tb i2c_if);
    wire signal;
    pullup (signal); // Pull-up resistor on the signal line

    assign signal = i2c_if.sda;

    initial begin
        i2c_if.start = 0;
        i2c_if.rst =1;
        #10 i2c_if.rst = 0;

        i2c_if.data_in = 8'b01001101;
        i2c_if.address = 8'b10101001;
        i2c_if.start = 1;
        #10 i2c_if.start = 0;

        #130
        i2c_if.start = 1;
        i2c_if.data_in = 8'b11001010;
        #40
        i2c_if.start = 0;
        
    end



endmodule
