module top ();
    bit clk;

    always #5 clk = ~clk; // Clock generation

    i2c_cont_if i2c_if (clk);
    i2c_controller i2c_controller (i2c_if); // Instantiate the I2C controller
    i2c_controller_tb i2c_controller_tb (i2c_if); // Instantiate the I2C controller testbench

    initial begin
        #2000
        $stop;
    end

endmodule
