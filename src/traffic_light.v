module traffic_light (
    input wire clk,
    input wire reset_n,
    input wire enable,
    output reg red,
    output reg yellow,
    output reg green
);

// Define the states
reg [1:0] current_state;
parameter RED = 2'b00, GREEN = 2'b01, YELLOW = 2'b10;

// Counter for clock cycles
reg [5:0] counter;

// Next state logic
always @(*) begin
    case (current_state)
        RED: begin
            if (counter >= 6'd31)
                current_state = GREEN;
        end
        GREEN: begin
            if (counter >= 6'd19)
                current_state = YELLOW;
        end
        YELLOW: begin
            if (counter >= 6'd6)
                current_state = RED;
        end
    endcase
end

// State and counter update
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        current_state <= RED;
        counter <= 6'd0;
    end else if (enable) begin
        if (current_state == RED && counter >= 6'd31) begin
            current_state <= GREEN;
            counter <= 6'd0;
        end else if (current_state == GREEN && counter >= 6'd19) begin
            current_state <= YELLOW;
            counter <= 6'd0;
        end else if (current_state == YELLOW && counter >= 6'd6) begin
            current_state <= RED;
            counter <= 6'd0;
        end else begin
            counter <= counter + 6'd1;
        end
    end
end

// Output logic
always @(*) begin
    red = (current_state == RED);
    green = (current_state == GREEN);
    yellow = (current_state == YELLOW);
end

endmodule

