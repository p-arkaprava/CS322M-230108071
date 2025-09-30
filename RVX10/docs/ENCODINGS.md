
## 📑 Encoding Table (Concrete)

| Instr | opcode (hex) | funct7 (bin) | funct3 (bin) | rs2 usage                |
|-------|--------------|--------------|--------------|--------------------------|
| ANDN  | 0x0B         | 0000000      | 000          | rs2                      |
| ORN   | 0x0B         | 0000000      | 001          | rs2                      |
| XNOR  | 0x0B         | 0000000      | 010          | rs2                      |
| MIN   | 0x0B         | 0000001      | 000          | rs2                      |
| MAX   | 0x0B         | 0000001      | 001          | rs2                      |
| MINU  | 0x0B         | 0000001      | 010          | rs2                      |
| MAXU  | 0x0B         | 0000001      | 011          | rs2                      |
| ROL   | 0x0B         | 0000010      | 000          | rs2\[4:0] for shamt      |
| ROR   | 0x0B         | 0000010      | 001          | rs2\[4:0] for shamt      |
| ABS   | 0x0B         | 0000011      | 000          | ignored (set rs2 = x0)   |

---

## 📑 RVX10 Instruction Semantics

| Name | Semantics (32-bit)                                   | Type | funct7  | funct3 |
|------|------------------------------------------------------|------|---------|--------|
| ANDN | `rd = rs1 & ~rs2`                                   | R    | 0000000 | 000    |
| ORN  | `rd = rs1 \| ~rs2`                                  | R    | 0000000 | 001    |
| XNOR | `rd = ~(rs1 ⊕ rs2)`                                 | R    | 0000000 | 010    |
| MIN  | `rd = (int32(rs1) < int32(rs2)) ? rs1 : rs2`        | R    | 0000001 | 000    |
| MAX  | `rd = (int32(rs1) > int32(rs2)) ? rs1 : rs2`        | R    | 0000001 | 001    |
| MINU | `rd = (rs1 < rs2) ? rs1 : rs2` (unsigned)           | R    | 0000001 | 010    |
| MAXU | `rd = (rs1 > rs2) ? rs1 : rs2` (unsigned)           | R    | 0000001 | 011    |
| ROL  | `rd = (rs1 << s) \| (rs1 >> (32-s))`, `s = rs2[4:0]`| R    | 0000010 | 000    |
| ROR  | `rd = (rs1 >> s) \| (rs1 << (32-s))`, `s = rs2[4:0]`| R    | 0000010 | 001    |
| ABS  | `rd = (int32(rs1) ≥ 0) ? rs1 : -rs1` (rs2 = x0)     | R    | 0000011 | 000    |






## Instruction format (R-type style used by RVX10)

Bit positions (MSB left):

```
 31        25 24   20 19   15 14   12 11    7 6     0
 +-------------+------+-------+-------+------+-------+
 |   func7     | rs2  | rs1   | func3 | rd   |  op   |
 +-------------+------+-------+-------+------+-------+
```

Field widths:

* func7: 7 bits (bits 31..25)
* rs2:   5 bits (bits 24..20)
* rs1:   5 bits (bits 19..15)
* func3: 3 bits (bits 14..12)
* rd:    5 bits (bits 11..7)
* op:    7 bits (bits 6..0)

All RVX10 custom instructions use the 7-bit opcode `0001011` for the new opcodes.

---
*x2=25;
*x9=18; 
Already been loaded before doing the below commands.

## Encoding table (concrete)

| func7   | rs2   | rs1   | func3 | rd    | op      | machine\_code | assembly         |
| ------- | ----- | ----- | ----- | ----- | ------- | ------------- | ---------------- |
| 0000000 | 01001 | 00010 | 000   | 01010 | 0001011 | 0x0091050B    | `ANDN x10,x2,x9` |
| 0000000 | 01001 | 00010 | 001   | 01011 | 0001011 | 0x0091158B    | `ORN  x11,x2,x9` |
| 0000000 | 01001 | 00010 | 010   | 01100 | 0001011 | 0x0091260B    | `XORN x12,x2,x9` |
| 0000001 | 01001 | 00010 | 000   | 01101 | 0001011 | 0x0291068B    | `MIN  x13,x2,x9` |
| 0000001 | 01001 | 00010 | 001   | 01110 | 0001011 | 0x0291170B    | `MAX  x14,x2,x9` |
| 0000001 | 01001 | 00010 | 010   | 01111 | 0001011 | 0x0291278B    | `MINU x15,x2,x9` |
| 0000001 | 01001 | 00010 | 011   | 10000 | 0001011 | 0x0291380B    | `MAXU x16,x2,x9` |
| 0000010 | 01001 | 00010 | 000   | 10001 | 0001011 | 0x0491088B    | `ROL  x17,x2,x9` |
| 0000010 | 00100 | 00100 | 001   | 10010 | 0001011 | 0x0442190B    | `ROR  x18,x4,x4` |
| 0000011 | 00000 | 10010 | 000   | 10011 | 0001011 | 0x0609098B    | `ABS  x19,x18`   |
| 0000010 | 00000 | 01001 | 001   | 10100 | 0001011 | 0x04049A0B    | `ROR  x20,x9,x0` |
| 0000000 | 01001 | 00010 | 000   | 00000 | 0001011 | 0x00910033    | `ADD  x0,x2,x9`  |

---