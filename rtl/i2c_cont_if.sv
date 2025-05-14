interface i2c_cont_if(input clk);
    logic rst, rw, start;
    logic [7:0] data_in;
    logic [7:0] address;
    logic sda, sda_drive, scl, scl_drive, ready, error;

    //assign sda = (sda_drive)? 1'bz : 1'b0;

    //clocking cb_clk @(posedge clk);
    //    default input #1ns output #3ns;
    //    input sda, sda_drive, scl, scl_drive, ready, error;
    //    output rst, rw, start, data_in, clk, address;
    //endclocking

    modport dut (
    input rst, rw, start, data_in, clk, address,
    output sda, sda_drive, scl, scl_drive, ready, error
    );

    modport tb (
    input sda, sda_drive, scl, scl_drive, ready, error,
    output rst, rw, start, data_in, clk, address
    );

endinterface // i2c_cont_if
