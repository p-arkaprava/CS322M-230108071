# RVX10: Extending RV32I with 10 Custom Instructions

This project extends the **RV32I single-cycle processor** with the **RVX10 ISA extension**:  
10 custom single-cycle instructions implemented using the reserved `CUSTOM-0` opcode (`0x0B` / `0001011`).

---

## 📂 Project Files

- `src/riscvsingle.sv` — modified RTL with RVX10 support.  
- `docs/ENCODINGS.md` — encodings (funct7/funct3/opcode) and machine code examples.  
- `docs/TESTPLAN.md` — test program and expected results.  
- `tests/rvx10.hex` (`rvx10.txt`) — hex image for `$readmemh`.

---

## 🔧 RTL Modifications

Below are all the places modified in `src/riscvsingle.sv` to support RVX10, with **line numbers and excerpts**.

---

### 1. Controller Instantiation (Top-Level)

**File:** `riscvsingle.sv`  
**Line ~144**

```verilog
144: controller c(Instr[6:0], Instr[14:12], Instr[30], Zero,
                 ResultSrc, MemWrite, PCSrc,
                 ALUSrc, RegWrite, Jump,
                 ImmSrc, ALUControl);
```

➡️ Added `Instr[30]` to pass the MSB of funct7 (`funct7b5`) for RVX10 decoding.  
*(Note: you should also wire `Instr[31:30]` into `funct7_2b` for the rotate/min/max groups.)*

---

### 2. Main Decoder (`maindec`) — New Opcode

**File:** `riscvsingle.sv`  
**Line ~198**

```verilog
198:   7'b0001011: controls = 11'b1_xx_0_0_00_0_11_0; // RVX10 custom ops
```

➡️ Added new case in opcode table for **CUSTOM-0** (`0001011`).

---

### 3. ALU Decoder (`aludec`) — Subdecode for RVX10

**File:** `riscvsingle.sv`  
**Lines ~227–246, ~330**

```verilog
227:   2'b11: case(funct7_2b)
228:       2'b00: case(funct3) // ANDN, ORN, XORN
229:           3'b000: alucontrol = 4'b0110; // ANDN
230:           3'b001: alucontrol = 4'b0111; // ORN
231:           3'b010: alucontrol = 4'b1000; // XORN
...
238:       2'b01: case(funct3) // MIN, MAX, MINU, MAXU
239:           3'b000: alucontrol = 4'b1001; // MIN
240:           3'b001: alucontrol = 4'b1010; // MAX
241:           3'b010: alucontrol = 4'b1011; // MINU
242:           3'b011: alucontrol = 4'b1100; // MAXU
...
246:       2'b11: alucontrol = 4'b1111; // ABS
```

➡️ Added `ALUOp = 2'b11` branch, mapping funct7/funct3 to new `ALUControl` values.

---

### 4. ALU (`alu` Module) — New Operations

**File:** `riscvsingle.sv`  
**Lines ~417–434**

```verilog
417:   4'b0110: result = a & ~b;              // ANDN
418:   4'b0111: result = a | ~b;              // ORN
419:   4'b1000: result = ~(a ^ b);            // XORN
420:   4'b1001: result = (s1 < s2) ? a : b;   // MIN (signed)
421:   4'b1010: result = (s1 > s2) ? a : b;   // MAX (signed)
422:   4'b1011: result = (a < b) ? a : b;     // MINU (unsigned)
423:   4'b1100: result = (a > b) ? a : b;     // MAXU (unsigned)
424:   4'b1101: begin // ROL
                 logic [4:0] sh = b[4:0];
                 result = (sh == 0) ? a : ((a << sh) | (a >> (32 - sh)));
               end
429:   4'b1110: begin // ROR
                 logic [4:0] sh = b[4:0];
                 result = (sh == 0) ? a : ((a >> sh) | (a << (32 - sh)));
               end
434:   4'b1111: result = (s1 >= 0) ? a : (0 - a); // ABS
```

➡️ Added 10 new `ALUControl` cases for RVX10 instructions.

---

## 📜 RVX10 Instruction Set

All instructions use opcode `0001011` (CUSTOM-0).

| Instruction | Semantics                               | funct7  | funct3 |
| ----------- | --------------------------------------- | ------- | ------ |
| **ANDN**    | `rd = rs1 & ~rs2`                       | 0000000 | 000    |
| **ORN**     | `rd = rs1 \| ~rs2`                      | 0000000 | 001    |
| **XORN**    | `rd = ~(rs1 ^ rs2)`                     | 0000000 | 010    |
| **MIN**     | signed min(rs1, rs2)                    | 0000001 | 000    |
| **MAX**     | signed max(rs1, rs2)                    | 0000001 | 001    |
| **MINU**    | unsigned min(rs1, rs2)                  | 0000001 | 010    |
| **MAXU**    | unsigned max(rs1, rs2)                  | 0000001 | 011    |
| **ROL**     | rotate left (rs1 by rs2[4:0])           | 0000010 | 000    |
| **ROR**     | rotate right (rs1 by rs2[4:0])          | 0000010 | 001    |
| **ABS**     | `rd = (rs1 >= 0) ? rs1 : -rs1` (rs2=x0) | 0000011 | 000    |

Full encoding details and hex examples are in [`docs/ENCODINGS.md`](docs/ENCODINGS.md).

---

## 🧪 Testing

* [`docs/TESTPLAN.md`](docs/TESTPLAN.md) — lists the assembly program and expected outputs.  
* [`tests/rvx10.hex`](tests/rvx10.hex) — machine code for `$readmemh`.  

Run the testbench:

* Final memory location `100` should contain **25**.  
* If correct, simulation prints:

```
Simulation succeeded
```

---

## ✅ Checklist

* [x] All 10 instructions added (CUSTOM-0, opcode `0001011`).  
* [x] Decode and ALU logic updated.  
* [x] Rotate by 0 handled.  
* [x] ABS of `INT_MIN` returns `0x80000000`.  
* [x] Writes to `x0` ignored.  
* [x] Testbench passes (store 25 @ address 100).
