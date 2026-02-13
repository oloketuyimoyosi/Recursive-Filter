module Recursive_Filter (
    input MAX10_CLK1_50,   // 50 MHz System Clock (Pin P11)
    input [9:0] SW,        // Switches (Pin C10, C11, etc.)
    output [9:0] LEDR      // LEDs (Pin A8, A9, etc.)
);

    // --- 1. CLOCK DIVIDER ---
    // The DE10-Lite runs at 50 MHz. We must slow it down to visible speed (~4Hz).
    // 50,000,000 / 12,500,000 = 4 Hz
    reg [23:0] counter;
    reg slow_clk;

    always @(posedge MAX10_CLK1_50) begin
        if (counter == 12500000) begin
            counter <= 0;
            slow_clk <= ~slow_clk; // Toggle slow clock
        end else begin
            counter <= counter + 1;
        end
    end

    // --- 2. SYSTEM IMPLEMENTATION ---
    // Equation: y[n] = 0.5*y[n-1] + x[n]
    reg [9:0] y_reg = 0;   // Using 10 bits to match the 10 LEDs
    wire [9:0] x_val;

    // Signal Mapping
    wire reset = SW[1];    // Switch 1 is Reset
    wire x_in  = SW[0];    // Switch 0 is Input x[n]

    // SCALING INPUT:
    // When Switch 0 is ON, we add a value (like 512) to represent "1.0".
    // This allows us to see the value decay across the LEDs.
    assign x_val = (x_in) ? 10'd512 : 10'd0;

    always @(posedge slow_clk or posedge reset) begin
        if (reset) begin
            y_reg <= 10'd0;
        end else begin
            // THE LTI EQUATION:
            // "y_reg >> 1" is the same as multiplying by 0.5
            y_reg <= (y_reg >> 1) + x_val;
        end
    end

    // --- 3. OUTPUT ---
    // Display the register value on the LEDs
    assign LEDR = y_reg;

endmodule