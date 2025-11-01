`timescale 1ns/1ps

module processor_tb;

    // Inputs
    reg clk;
    reg rst;

    // Instantiate the processor
    processor uut (
        .clk(clk),
        .rst(rst)
    );

    // Clock generation: 10ns period
    always #20 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 0;
        rst = 1;

        // Apply reset
        #20;
        rst = 0;

        // Run simulation for a while
        #500;

        // Finish simulation
        $finish;
    end

    // Optional: waveform dump (for GTKWave)
    initial begin
        $dumpfile("processor_tb.vcd");
        $dumpvars(0, processor_tb);
    end

endmodule
