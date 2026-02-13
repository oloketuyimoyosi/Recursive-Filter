# Modeling an LTI System on FPGA (LAG-EEG 213)

**Author:** David Oloketuyi  
**Course:** LAG-EEG 213 (Systems Engineering)  
**Institution:** University of Lagos  
**Hardware:** Terasic DE10-Lite (MAX 10 FPGA)  

---

## 📌 Project Overview
This repository contains the Verilog implementation of a **First-Order Linear Time-Invariant (LTI) System** on a DE10-Lite FPGA board. 

[cite_start]The goal of this lab is to bridge the gap between abstract mathematical models and physical hardware by implementing a difference equation using digital logic gates, registers, and clock dividers[cite: 6, 9].

### The Mathematical Model
The system is defined by the discrete-time difference equation:

$$y[n] = 0.5y[n-1] + x[n]$$

Where:
* $y[n]$ is the current output.
* $y[n-1]$ is the previous output (stored in memory).
* $x[n]$ is the current input (from a switch).
* $0.5$ is the decay coefficient (implemented as a bit-shift).

---

## ⚙️ System Properties
[cite_start]Based on the analysis performed for the lab report[cite: 25, 26, 27, 28]:

| Property | Status | Proof Summary |
| :--- | :--- | :--- |
| **Linearity** | ✅ Yes | Satisfies superposition ($T\{ax_1 + bx_2\} = ay_1 + by_2$). |
| **Time-Invariance** | ✅ Yes | The coefficient ($0.5$) is constant and does not depend on $n$. |
| **Causality** | ✅ Yes | Output depends only on current input and past output. |
| **Stability** | ✅ Yes | The pole is at $0.5$ ($|z| < 1$), ensuring BIBO stability. |

---

## 🛠️ Hardware Implementation

### Features
* **Clock Division:** The DE10-Lite's 50 MHz clock is divided down to approximately **4 Hz** so the state changes are visible to the human eye.
* **Bitwise Optimization:** The multiplication by $0.5$ is implemented as a **Right Bit Shift (`>> 1`)**, which is computationally efficient in hardware.
* **Visual Feedback:** The system state is displayed on the 10 LEDs (LEDR0 - LEDR9).

### Pin Assignments (DE10-Lite)
If you are setting this up manually in Quartus Prime, ensure the following pins are assigned:

| Signal | PIN | Description |
| :--- | :--- | :--- |
| `MAX10_CLK1_50` | `PIN_P11` | 50 MHz Clock Source |
| `SW[0]` | `PIN_C10` | **Input x[n]** (Step/Pulse Input) |
| `SW[1]` | `PIN_C11` | **Reset** (Active High) |
| `LEDR[0..9]` | `PIN_A8`.. | System Output Display (10-bit) |

---

## 📂 Code Structure

### `Recursive_Filter.v`
The main module containing the logic. It handles the clock division and the recursive difference equation.

```verilog
// Key Logic Snippet
always @(posedge slow_clk or posedge reset) begin
    if (reset) begin
        y_reg <= 10'd0;
    end else begin
        // Implements y[n] = 0.5*y[n-1] + x[n]
        y_reg <= (y_reg >> 1) + x_val; 
    end
end

### Clone the Repository:

```Bash
git clone [https://github.com/YOUR_USERNAME/LTI-System-FPGA.git](https://github.com/YOUR_USERNAME/LTI-System-FPGA.git)
```
### Open in Quartus Prime:

*Open the .qpf project file.

### Compile:

*Run Analysis & Synthesis to check for errors.
*Run Fitter and Assembler to generate the bitstream.

### Program the Board:

*Connect the DE10-Lite via USB.
*Open the Programmer tool and upload the .sof file.