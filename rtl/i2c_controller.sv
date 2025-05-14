typedef enum { IDLE, ADDRESS, DATA, ERROR } state_t;

module i2c_controller (i2c_cont_if.dut i2c_if);
    
    state_t current_state;
    state_t next_state;
    
    reg [7:0] address = 8'b10101001;
    reg [7:0] data;
    logic [3:0] bit_count;
    
    always @(posedge i2c_if.clk) begin
        if (i2c_if.rst) begin
            i2c_if.sda = 1;
            current_state <= IDLE;
            next_state <= IDLE;
            bit_count <= 0;
        end
        else begin
            case (current_state)
                IDLE: begin
                    if (i2c_if.start) begin
                        data <= i2c_if.data_in;
                        i2c_if.sda = 0;
                        next_state <= ADDRESS;
                    end
                    else
                        i2c_if.sda = 1;
                end
                ADDRESS: begin
                    if (bit_count < 8) begin
                        i2c_if.sda = address[7 - bit_count];
                        bit_count <= bit_count + 1;
                        if (bit_count == 7) begin
                            bit_count <= 0;
                            next_state <= DATA;

                        end
                    end
                end
                DATA: begin
                    if (bit_count < 8) begin
                        i2c_if.sda = data[7 - bit_count];
                        bit_count <= bit_count + 1;
                        if (bit_count == 7) begin
                            next_state <= IDLE;
                        end
                    end
                end
                default: ;
            endcase
            current_state <= next_state;
        end
    end
endmodule
