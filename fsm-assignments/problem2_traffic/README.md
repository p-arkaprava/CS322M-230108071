# Traffic Light Controller (Verilog)

## Overview
This project implements a **traffic light controller FSM** in Verilog.  
The system cycles through:

- **North–South Green** (5 seconds)  
- **North–South Yellow** (2 seconds)  
- **East–West Green** (5 seconds)  
- **East–West Yellow** (2 seconds)  

The FSM uses a **per-second tick pulse** to update its state timing.

---

## How the 1 Hz Tick is Generated
On a real FPGA (with 100 MHz input clock), a divider module would be used:

- Count 100,000,000 clock cycles = 1 second  
- Emit a **1-cycle-wide tick pulse** at exactly 1 Hz  
- The FSM only updates on that tick  

This way, the traffic lights advance **once per real second**.

---

## Simulation Tick Generator
Simulating a full 1 Hz tick with a 100 MHz clock would require billions of cycles – not practical.  

So in the **testbench (`tb_traffic_light.v`)**:
- A small counter is used to generate a **tick every 5 cycles**.  
- This tick is still **1-cycle wide**, just much faster than real hardware.  
- Functionality is preserved, but simulation runs quickly.

```verilog
always @(posedge clk) begin
    if (rst) begin
        cyc  <= 0;
        tick <= 0;
    end else begin
        cyc  <= cyc + 1;
        tick <= (cyc % 5 == 0);  // tick every 5 cycles (fast sim)
    end
end
