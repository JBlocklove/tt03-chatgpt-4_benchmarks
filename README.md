![](../../workflows/gds/badge.svg) ![](../../workflows/docs/badge.svg) ![](../../workflows/wokwi_test/badge.svg)


# Fully ChatGPT-4 Created Benchmarks
This design implements a series of 8 benchmark circuits selectable by 3 bits of the design input, all of which written by ChatGPT-4. A series of prompts for each circuit were created which had ChatGPT design the module itself as well as a Verilog testbench for the design, and the design was considered finalized when there were no errors from simulation or synthesis. As much of the feedback as possible was given by the tools -- [Icarus Verilog](https://github.com/steveicarus/iverilog) for simulation and the Tiny Tapeout OpenLane/yosys toolchain for synthesis.

As a result of the designs being 100% created by ChatGPT, they all passed their ChatGPT-created testbenches, but several are not functionally correct as the generated testbenches are insufficient or incorrect. The best example of this is the **Dice Roller** benchmark, which has a constant output but passes its testbench fully.

The complete transcripts of the ChatGPT conversations can be found at https://github.com/JBlocklove/tt03-chatgpt-4_benchmarks/tree/main/conversations

---

### Wrapper Module/Multiplexer

##### ChatGPT Prompt
```
I am trying to create a Verilog model for a wrapper around several benchmarks, sepecifically for the Tiny Tapeout project. It must meet the following specifications:
    - Inputs:
        - io_in (8-bits)
    - Outputs:
        - io_out (8-bits)

The design should instantiate the following modules, and use 3 bits of the 8-bit input to select which one will output from the module.

Benchmarks:
    - shift_register:
	    - Inputs:
	    	- clk
	    	- reset_n
	    	- data_in
	    	- shift_enable
	    - Outputs:
	    	- [7:0] data_out

    - sequence_generator:
	    - Inputs:
	    	- clock
	    	- reset_n
	    	- enable
	    - Outputs:
	    	- [7:0] data

    - sequence_detector:
	    - Inputs:
	    	- clk
	    	- reset_n
	    	- [2:0] data
	    - Outputs:
	    	- sequence_found

    - abro_state_machine:
        - Inputs:
            - clk
            - reset_n
            - A
            - B
        - Outputs:
            - O
            - [3:0] state

    - binary_to_bcd:
	    - Inputs:
	    	- [4:0] binary_input
	    - Outputs:
	    	- [3:0] bcd_tens
            - [3:0] bcd_units

    - lfsr:
	    - Inputs:
	    	- clk
            - reset_n
	    - Outputs:
	    	- [7:0] data

    - traffic_light:
        - Inputs:
            - clk
            - reset_n
            - enable
        - Outputs:
            - red
            - yellow
            - green

    - dice_roller:
        - Inputs:
            - clk
            - reset_n
            - [1:0] die_select
            - roll
        - Outputs:
            - rolled_number

How would I write a design that meets these specifications?
```

##### Benchmark I/O Mapping

| `io_in[7:5]`   | Benchmark          |
|---------------:|:-------------------|
| `000`          | Shift Register     |
| `001`          | Sequence Generator |
| `010`          | Sequence Detector  |
| `011`          | ABRO               |
| `100`          | Binary to BCD      |
| `101`          | LFSR               |
| `110`          | Traffic Light      |
| `111`          | Dice Roller        |

##### Expected Functionality

The top level module for the design is a wrapper module/multiplexer which allows the user to select which benchmark is being used for the output of the design. Using `io_in[7:5]`, the user can select which benchmark will output to the `io_out` pins.

This module was created after all of the other designs were finalized so their port mappings could be given

##### Actual Functionality

The module functions as intended. This is the only module with a human-written testbench, as it seemed unrealistic to have ChatGPT create a full testbench that confirmed the module instantiations worked given how much it struggled with some of the other testbenches.

---

### Shift Register

##### ChatGPT Prompt

```
I am trying to create a Verilog model for a shift register. It must meet the following
specifications:
	- Inputs:
		- Clock
		- Active-low reset
		- Data (1 bit)
		- Shift enable
	- Outputs:
		- Data (8 bits)

How would I write a design that meets these specifications?
```

##### Benchmark I/O Mapping

| # | Input           | Output             |
|---|-----------------|--------------------|
| 0 | `clk`           | Shifted data [0]   |
| 1 | `rst_n` (async) | Shifted data [1]   |
| 2 | `data_in`       | Shifted data [2]   |
| 3 | `shift_enable`  | Shifted data [3]   |
| 4 | Not used        | Shifted data [4]   |
| 5 | Not used        | Shifted data [5]   |
| 6 | Not used        | Shifted data [6]   |
| 7 | Not used        | Shifted data [7]   |

##### Expected Functionality

The expected functionality of this shift register module is to shift the `data_in` bit in on the right side of the data vector on any rising `clk` edge where `shift_enable` is high.

##### Actual Functionality

The module seems to function as intended.

---

### Sequence Generator

##### ChatGPT Prompt
```
I am trying to create a Verilog model for a sequence generator. It must meet the following
specifications:
	- Inputs:
		- Clock
		- Active-low reset
		- Enable
	- Outputs:
		- Data (8 bits)

While enabled, it should generate an output sequence of the following hexadecimal values and
then repeat:
	- 0xAF
	- 0xBC
	- 0xE2
	- 0x78
	- 0xFF
	- 0xE2
	- 0x0B
	- 0x8D

How would I write a design that meets these specifications?
```

##### Benchmark I/O Mapping

| # | Input           | Output                |
|---|-----------------|-----------------------|
| 0 | `clk`           | Sequence Output [0]   |
| 1 | `rst_n` (async) | Sequence Output [1]   |
| 2 | Not used        | Sequence Output [2]   |
| 3 | Not used        | Sequence Output [3]   |
| 4 | `enable`        | Sequence Output [4]   |
| 5 | Not used        | Sequence Output [5]   |
| 6 | Not used        | Sequence Output [6]   |
| 7 | Not used        | Sequence Output [7]   |

##### Expected Functionality

The expected functionality of this sequence generator is to output the following sequence, moving a step forward whenever the `clk` has a rising edge and the `enable` is high. Once the sequence has reached its end it should repeat.

```
0xAF
0xBC
0xE2
0x78
0xFF
0xE2
0x0B
0x8D
```

##### Actual Functionality

The module functions as intended.

---

### Sequence Detector

##### ChatGPT Prompt
```
I am trying to create a Verilog model for a sequence detector. It must meet the following
specifications:
	- Inputs:
		- Clock
		- Active-low reset
		- Data (3 bits)
	- Outputs:
		- Sequence found

While enabled, it should detect the following sequence of binary input values:
	- 0b001
	- 0b101
	- 0b110
	- 0b000
	- 0b110
	- 0b110
	- 0b011
	- 0b101

How would I write a design that meets these specifications?
```

##### Benchmark I/O Mapping

| # | Input           | Output                |
|---|-----------------|-----------------------|
| 0 | `clk`           | Not Used              |
| 1 | `rst_n` (async) | Not Used              |
| 2 | `data[0]`       | Not Used              |
| 3 | `data[1]`       | Not Used              |
| 4 | `data[2]`       | Not Used              |
| 5 | Not used        | Not Used              |
| 6 | Not used        | Not Used              |
| 7 | Not used        | Sequence Found        |

##### Expected Functionality

The expected functionality of this sequence detector is to output a `1` if it receives the following sequence of data all on consecutive clock cycles.

```
0b001
0b101
0b110
0b000
0b110
0b110
0b011
0b101
```

##### Actual Functionality

The module does not correctly detect the sequence. In trying to set the states to allow the sequence to overlap it instead skips the final value or outputs a `1` if the second to last value and final value are both `0b101`.

---

### ABRO State Machine

##### ChatGPT Prompt
```
I am trying to create a Verilog model for an ABRO state machine. It must meet the following
specifications:
    - Inputs:
        - Clock
        - Active-low reset
        - A
        - B
    - Outputs:
        - O
        - State

Other than the main output from ABRO machine, it should output the current state of the machine
for use in verification.

The states for this state machine should be one-hot encoded.

How would I write a design that meets these specifications?
```

##### Benchmark I/O Mapping

| # | Input             | Output                |
|---|-------------------|-----------------------|
| 0 | `clk`             | State [0]             |
| 1 | `reset_n` (async) | State [1]             |
| 2 | `A`               | State [2]             |
| 3 | `B`               | State [3]             |
| 4 | Not used          | Output                |
| 5 | Not used          | Not used              |
| 6 | Not used          | Not used              |
| 7 | Not used          | Not used              |

##### Expected Functionality

The expected functionality of the ABRO (A, B, Reset, Output) state machine is to only reach the output state and output a `1` when both inputs `A` and `B` have been given before a reset. The order of the inputs should not matter, so long as both `A` and `B` are set.

##### Actual Functionality

The module does not function fully as intended. If `B` is received before `A` then it works as intended, but if `A` is received first then it actually requires the sequence `A, B, A` in order to reach the output state. It also does not handle the case where `A` and `B` are set in the same cycle, instead interpreting it as if `A` was received first.

---

### Binary to BCD Converter

##### ChatGPT Prompt
```
I am trying to create a Verilog model for a binary to binary-coded-decimal converter. It must
meet the following specifications:
	- Inputs:
		- Binary input (5-bits)
	- Outputs:
		- BCD (8-bits: 4-bits for the 10's place and 4-bits for the 1's place)

How would I write a design that meets these specifications?
```

##### Benchmark I/O Mapping

| # | Input             | Output         |
|---|-------------------|----------------|
| 0 | `binary_input[0]` | BCD Ones [0]   |
| 1 | `binary_input[1]` | BCD Ones [1]   |
| 2 | `binary_input[2]` | BCD Ones [2]   |
| 3 | `binary_input[3]` | BCD Ones [3]   |
| 4 | `binary_input[4]` | BCD Tens [0]   |
| 5 | Not used          | BCD Tens [1]   |
| 6 | Not used          | BCD Tens [2]   |
| 7 | Not used          | BCD Tens [3]   |

##### Expected Functionality

The expected functionality of this module is to take a 5-bit binary number and produce a binary-coded-decimal output. The 4 most significant bits of the output encode to the tens place of the decimal number, the 4 least signification bits of the output encode the ones place of the decimal number

##### Actual Functionality

The module functions as intended.

---

### Linear Feedback Shift Register (LFSR)

##### ChatGPT Prompt
```
I am trying to create a Verilog model for an LFSR. It must meet the following specifications:
	- Inputs:
		- Clock
        - Active-low reset
	- Outputs:
		- Data (8-bits)

The initial state should be 10001010, and the taps should be at locations 1, 4, 6, and 7.

How would I write a design that meets these specifications?
```

##### Benchmark I/O Mapping

| # | Input           | Output            |
|---|-----------------|-------------------|
| 0 | `clk`           | Data Output [0]   |
| 1 | `rst_n` (async) | Data Output [1]   |
| 2 | Not used        | Data Output [2]   |
| 3 | Not used        | Data Output [3]   |
| 4 | Not used        | Data Output [4]   |
| 5 | Not used        | Data Output [5]   |
| 6 | Not used        | Data Output [6]   |
| 7 | Not used        | Data Output [7]   |

##### Expected Functionality

##### Actual Functionality

---

### Traffic Light State Machine

##### ChatGPT Prompt
```
I am trying to create a Verilog model for a traffic light state machine. It must meet the
following specifications:
    - Inputs:
        - Clock
        - Active-low reset
        - Enable
    - Outputs:
        - Red
        - Yellow
        - Green

The state machine should reset to a red light, change from red to green after 32 clock cycles,
change from green to yellow after 20 clock cycles, and then change from yellow to red after 7
clock cycles.

How would I write a design that meets these specifications?
```

##### Benchmark I/O Mapping

| # | Input           | Output                |
|---|-----------------|-----------------------|
| 0 | `clk`           | Sequence Output [0]   |
| 1 | `rst_n` (async) | Sequence Output [1]   |
| 2 | Not used        | Sequence Output [2]   |
| 3 | `enable`        | Sequence Output [3]   |
| 4 | Not used        | Sequence Output [4]   |
| 5 | Not used        | Green                 |
| 6 | Not used        | Yellow                |
| 7 | Not used        | Red                   |

##### Expected Functionality

The expected functionality of this module is to simulate the function of a timed traffic light. On a reset it outputs a red light, waits 32 clock cycles and then changed to a green light, waits 20 clock cycles and then changes to a yellow light, waits 7 clock cycles and then changes back to red. This should then repeat. If the enable is low, then it should pause the operation entirely and pick up again once the enable is brought high again.

##### Actual Functionality

The module functions as intended.

---

### Dice Roller

##### ChatGPT Prompt
```
I am trying to create a Verilog model for a simulated dice roller. It must meet the following
specifications:
    - Inputs:
        - Clock
        - Active-low reset
        - Die select (2-bits)
        - Roll
    - Outputs:
        - Rolled number (up to 8-bits)

The design should simulate rolling either a 4-sided, 6-sided, 8-sided, or 20-sided die, based on
the input die select. It should roll when the roll input goes high and output the random number
based on the number of sides of the selected die.

How would I write a design that meets these specifications?
```

##### Benchmark I/O Mapping

| # | Input           | Output                |
|---|-----------------|-----------------------|
| 0 | `clk`           | Dice Roll [0] |
| 1 | `rst_n` (async) | Dice Roll [1] |
| 2 | `die_select[1]` | Dice Roll [2] |
| 3 | `die_select[0]` | Dice Roll [3] |
| 4 | `roll`          | Dice Roll [4] |
| 5 | Not used        | Dice Roll [5] |
| 6 | Not used        | Dice Roll [6] |
| 7 | Not used        | Dice Roll [7] |

##### Expected Functionality

The expected functionality of this dice roller is to allow the user to select which die they would like to simulate rolling based on the following table:

| `die_select` | Number of sides |
|-------------:|:----------------|
| `00`         | 4               |
| `01`         | 6               |
| `10`         | 8               |
| `11`         | 20              |

When `roll` is high the module should output a new pseudo-random value in the range `[1 - Number of sides]`

##### Actual Functionality

This module outputs `2` for the first two dice rolls and then consistently outputs a `1` regardless of what die is selected.

---
---

# What is Tiny Tapeout?

TinyTapeout is an educational project that aims to make it easier and cheaper than ever to get your digital designs manufactured on a real chip!

Go to https://tinytapeout.com for instructions!

## How to change the Wokwi project

Edit the [info.yaml](info.yaml) and change the wokwi_id to match your project.

## How to enable the GitHub actions to build the ASIC files

Please see the instructions for:

* [Enabling GitHub Actions](https://tinytapeout.com/faq/#when-i-commit-my-change-the-gds-action-isnt-running)
* [Enabling GitHub Pages](https://tinytapeout.com/faq/#my-github-action-is-failing-on-the-pages-part)

## How does it work?

When you edit the info.yaml to choose a different ID, the [GitHub Action](.github/workflows/gds.yaml) will fetch the digital netlist of your design from Wokwi.

After that, the action uses the open source ASIC tool called [OpenLane](https://www.zerotoasiccourse.com/terminology/openlane/) to build the files needed to fabricate an ASIC.

## Resources

* [FAQ](https://tinytapeout.com/faq/)
* [Digital design lessons](https://tinytapeout.com/digital_design/)
* [Learn how semiconductors work](https://tinytapeout.com/siliwiz/)
* [Join the community](https://discord.gg/rPK2nSjxy8)

## What next?

* Share your GDS on Twitter, tag it [#tinytapeout](https://twitter.com/hashtag/tinytapeout?src=hashtag_click) and [link me](https://twitter.com/matthewvenn)!
