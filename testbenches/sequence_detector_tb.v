`timescale 1ns/1ps

module tb_sequence_detector;

    reg clk;
    reg reset_n;
    reg [2:0] data;
    wire sequence_found;

    // Instantiate the sequence_detector module
    sequence_detector uut (
        .clk(clk),
        .reset_n(reset_n),
        .data(data),
        .sequence_found(sequence_found)
    );

    // Clock generation
    always begin
        #5 clk = ~clk;
    end

    // Test cases
    reg [2:0] test_case_data [0:7];
    reg [0:7] test_case_sequence_found;

    // Test case initialization
    integer i;
    initial begin
        for (i = 0; i < 8; i = i + 1) begin
            case (i)
                0: begin
                    test_case_data[i] = 3'b001;
                    test_case_sequence_found[i] = 1'b0;
                end
                1: begin
                    test_case_data[i] = 3'b101;
                    test_case_sequence_found[i] = 1'b0;
                end
                2: begin
                    test_case_data[i] = 3'b110;
                    test_case_sequence_found[i] = 1'b0;
                end
                3: begin
                    test_case_data[i] = 3'b000;
                    test_case_sequence_found[i] = 1'b0;
                end
                4: begin
                    test_case_data[i] = 3'b110;
                    test_case_sequence_found[i] = 1'b1;
                end
                5: begin
                    test_case_data[i] = 3'b110;
                    test_case_sequence_found[i] = 1'b1;
                end
                6: begin
                    test_case_data[i] = 3'b011;
                    test_case_sequence_found[i] = 1'b0;
                end
                7: begin
                    test_case_data[i] = 3'b101;
                    test_case_sequence_found[i] = 1'b1;
                end
            endcase
        end
    end

    // Test case execution
    initial begin
        $display("Starting simulation...");
        clk = 0;
        reset_n = 0;
        data = 3'b000;
        #10 reset_n = 1;

        for (i = 0; i < 8; i = i + 1) begin
            data = test_case_data[i];
            #10;

            if (sequence_found !== test_case_sequence_found[i]) begin
                $display("Error: Test case %0d failed. data: %b, expected sequence_found: %b, got: %b",
                         i, data, test_case_sequence_found[i], sequence_found);
            end else begin
                $display("Test case %0d passed.", i);
            end
        end

        $display("Simulation finished.");
        $finish;
    end
endmodule

