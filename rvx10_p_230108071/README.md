# 🧠 RVX10-P: 5-Stage Pipelined RISC-V Core

**RVX10-P** is a **five-stage pipelined RISC-V processor (RV32I)** enhanced with **10 custom ALU instructions** under the **RVX10 extension**.  
Developed as part of the course **Digital Logic and Computer Architecture** taught by **Dr. Satyajit Das**, **IIT Guwahati**.

---

## 🚀 Overview

RVX10-P transforms a single-cycle implementation into a **high-throughput pipelined core** by partitioning the datapath into five classic stages:

> **IF → ID → EX → MEM → WB**

The processor handles **data and control hazards** effectively using dedicated **Forwarding** and **Hazard** units, ensuring correct execution and efficient performance.

---

## ⚙️ Key Features

### 🧩 Pipeline Architecture
- **5-Stage Pipelined Datapath:** IF, ID, EX, MEM, WB
- **Base ISA:** Fully implements the **RV32I** instruction set
- **Custom Extension (RVX10):** Adds 10 ALU operations:
ANDN, ORN, XNOR, MIN, MAX, MINU, MAXU, ROL, ROR, ABS

### 🔁 Hazard Handling
- **Forwarding Unit:**  
Resolves **Read-After-Write (RAW)** data hazards from **MEM** and **WB** stages.
- **Hazard Unit:**  
Handles **load-use stalls** (1-cycle bubble) and **branch flushes** (via NOP insertion).

### ⚡ Performance
- Achieves an **average CPI ≈ 1.258** on the comprehensive test suite.
- Demonstrates **high throughput and efficiency** compared to the single-cycle version.

---




During testing, the **RVX10-P** core achieved **39 cycles for 31 instructions**, giving an **average CPI ≈ 1.258**.  
However, this result is **abstract** — it was not based on a standardized benchmark suite but rather on a self-constructed instruction sequence.
Now I can also design a testbench which contains 51 instructions containing only 2 branch instructions that are successful. So by theoretical calculations I will get CPI as 59/51= 1.156.
So, In my testbench as you keep branch and jump instructions constant and increase the testbench by adding instructions other than branch, jump or load, you can potentially even reach nearer to 1 CPI.

### 💡 Proposed Improvement
A key next step would be to:
- **Design a dedicated benchmark-driven testbench**, simulating realistic instruction mixes (arithmetic, logic, load/store, branch, and jump operations).
- **Compare theoretical and practical CPI values**, refining the pipeline control and forwarding mechanisms to minimize stalls and bubbles.

### 🧩 Outcome
This enhancement would make the performance analysis more robust, allowing future iterations of **RVX10-P** to:
- Achieve **benchmark-consistent CPI values**
- **Validate real-world throughput efficiency**
- Strengthen the design’s credibility through **quantitative comparison** of simulated vs. theoretical results.






## 📚 References

This project’s design and pipeline architecture are based on:

> **Digital Design and Computer Architecture (RISC-V Edition)**  
> *David Harris and Sarah Harris*

---

## 🏫 Acknowledgment

Developed under the guidance of  
**Dr. Satyajit Das**  
*Assistant Professor*  
Department of **Computer Science and Engineering**  
**Indian Institute of Technology, Guwahati**

