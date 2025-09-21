// Finite State Machine

module fsm #(
    parameter BLINK_INTERVAL = 2000000,     // CLK freq is 12MHz, so 6,000,000 cycles is 0.5s
)(
    input logic     clk, 
    output logic    red, 
    output logic    green, 
    output logic    blue
);
    logic [2:0] RGB;
    assign {red, green, blue} = RGB;

    // Define state variable values
    localparam [2:0] RED = 3'b100;
    localparam [2:0] YELLOW = 3'b110;
    localparam [2:0] GREEN = 3'b010;
    localparam [2:0] CYAN = 3'b011;
    localparam [2:0] BLUE = 3'b001;
    localparam [2:0] MAGENTA = 3'b101;

    logic [2:0] current_state = RED;
    logic [2:0] next_state;

    // Declare counter variables for blinking interval
    logic [$clog2(BLINK_INTERVAL) - 1:0] count = 0;
    logic state_change;

    // Register the next state of the FSM
    always_ff @(posedge clk) begin
        if (state_change)
            current_state <= next_state;
    end

    always_ff @(posedge clk)
        if (count == BLINK_INTERVAL - 1) begin
            count <= 0;
            state_change <= 1'b1;
        end else begin
            count <= count + 1;
            state_change <= 1'b0;
        end
    
    // Compute the next state of the FSM
    always_comb begin
        next_state = 3'bxxx;
        case (current_state)
            RED:    next_state = YELLOW;
            YELLOW: next_state = GREEN;
            GREEN:  next_state = CYAN;
            CYAN:   next_state = BLUE;
            BLUE:   next_state = MAGENTA;
            MAGENTA: next_state = RED;
            default: next_state = RED;
        endcase
    end

    // Register the FSM outputs
    always_ff @(posedge clk) begin
        RGB <= current_state;
    end
endmodule





 