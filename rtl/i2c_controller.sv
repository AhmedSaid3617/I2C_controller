typedef enum { IDLE, ADDRESS, DATA, ACK, ERROR } state_t;

module i2c_controller(i2c_cont_if.dut i2c_if);

    // Internal registers
    state_t current_state, next_state;
    logic [7:0] address = 8'b10101001;
    logic [7:0] data;
    logic [3:0] bit_count;

    

    // Sequential logic for state and counters
    always_ff @(posedge i2c_if.clk or posedge i2c_if.rst) begin
        if (i2c_if.rst) begin
            current_state <= IDLE;
            bit_count <= 0;
            data <= 8'd0;
        end else begin
            current_state <= next_state;

            case (current_state)
                ADDRESS, DATA: begin
                    if (bit_count < 7)
                        bit_count <= bit_count + 1;
                    else
                        bit_count <= 0;
                end

                IDLE, ACK: begin
                    if (i2c_if.start) begin
                        data <= i2c_if.data_in;
                    end
                end
                default: bit_count <= 0;
            endcase

            
        end
    end

    // Combinational logic for state transitions and SDA output
    always_comb begin
        next_state = current_state;
        i2c_if.sda = 1'b1;  // default

        case (current_state)
            IDLE: begin
                if (i2c_if.start) begin
                    next_state <= ADDRESS;
                    i2c_if.sda = 1'b0; // Start condition (pull SDA low)
                end
                else begin
                    next_state <= IDLE;
                end
            end

            ADDRESS: begin
                i2c_if.sda = address[7 - bit_count];
                if (bit_count == 7) begin
                    next_state = DATA;
                end
            end

            DATA: begin
                i2c_if.sda = data[7 - bit_count];

                if (bit_count == 7) begin
                    next_state = ACK;
                end
            end

            ACK: begin
                i2c_if.sda = 1;
                if (i2c_if.start) begin
                    next_state <= DATA;
                end
                else
                    next_state <= IDLE;
                
            end

            default: next_state = ERROR;
        endcase
    end

endmodule
