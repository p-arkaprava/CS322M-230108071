# Serial Pattern Detector (Mealy FSM) — Detect `1101` with Overlap

## Goal
Design and verify a Mealy FSM that detects the serial bit pattern `1101` on input `din` with overlap.  
The output `y` generates a **1-cycle pulse** when the last bit (`1`) of the sequence arrives.

- **FSM Type**: Mealy  
- **Reset**: Synchronous, active-high  

---

## State Diagram
- Labeled states represent progress through the pattern.  
- Transitions handle overlaps (e.g., `1101101` still triggers detections).  
- Output `y=1` only when full pattern `1101` is detected.  

![State Diagram](https://github.com/user-attachments/assets/0ce83508-9a08-42a8-af7d-72b6f3b426d4)
![Block Design](https://github.com/user-attachments/assets/b54f6003-c9cb-42f5-b0d0-f8b14e0d7450)

---

## Waveform
The testbench generates serial input streams on `din`.  
- `y` pulses high for **1 clock cycle** whenever `1101` is detected.  
- Overlaps are supported: e.g., input `1101101` gives **two pulses**.  

![Waveform](https://github.com/user-attachments/assets/c1e44a1d-78a6-453f-8bb7-600ea8b92385)

## How to Run (Vivado)

1. Open Vivado and create a new project:

---2. Add the source files:
- `seq_detect_mealy.v`  
- `tb_seq_detect_mealy.v`
3. Set the simulation top module to `tb_seq_detect_mealy`.
4. Run **Behavioral Simulation**.
5. Open the **waveform viewer** to verify detection pulses.

---

## Expected Behavior
| Input Stream (`din`) | Detection Pulses (`y`) |
|-----------------------|-------------------------|
| `1101`               | Pulse at last bit       |
| `1101101`            | Two pulses (overlap)    |
| `11101`              | Pulse when last `1` arrives |
| `01101101`           | Two pulse               |

---

## GitHub Submission
- **Repo URL**: *[(https://github.com/spandanb10745/CS322M-230102108)]*  
- **Final Commit Hash**: *[replace with latest commit hash]*  

---

## Author
- Name: *SPANDAN BHARADWAJ*  
- Course/Assignment: *CS_322_M*  



