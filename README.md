# Simple-8 Pipelined RISC Processor

A 5-stage pipelined RISC processor designed from scratch in SystemVerilog, featuring data forwarding and hazard detection, verified through simulation and successfully deployed on a Basys3 FPGA board.

---

## Performance Results

| Metric               | Value            |
|----------------------|------------------|
| Clock Frequency      | 160 MHz          |
| LUT Utilization      | 84 / 20800 (0.4%)|
| Slice Registers      | 156 / 41600 (0.37%)|
| Total On-Chip Power  | 75 mW            |
| CPI (w/ forwarding)  | ~2.3             |
| Pipeline Stages      | 5                |

---

## Features

- 5-stage pipeline (IF → ID → EX → MEM → WB)
- Data forwarding unit (EX→EX and MEM→EX paths)
- Hazard detection unit (handles LOAD-USE hazards)
- Custom 16-bit ISA with 10 instructions
- Real-time register visualization on Basys3 board (7-segment display + LEDs)
- Manual single-step clock mode for debugging
- Configurable clock speed (1 Hz to 10 KHz)

---

## Instruction Set Architecture (ISA)

**16-bit Instruction Format:**
```
[15:12] = Opcode     (4 bits)
[11:10] = rd         (destination register, 2 bits)
[9:8]   = rs         (source register 1, 2 bits)
[7:6]   = rt         (source register 2, 2 bits)
[9:2]   = Immediate  (8 bits, for I-type instructions)
```

**Supported Instructions:**

| Instruction | Opcode | Type   | Description               |
|-------------|--------|--------|---------------------------|
| ADD         | 0000   | R-type | rd = rs + rt              |
| SUB         | 0001   | R-type | rd = rs - rt              |
| AND         | 0010   | R-type | rd = rs & rt              |
| OR          | 0011   | R-type | rd = rs OR rt             |
| LOAD        | 0100   | I-type | rd = mem[immediate]       |
| STORE       | 0101   | I-type | mem[immediate] = rd       |
| LOADI       | 0110   | I-type | rd = immediate            |
| BEQ         | 0111   | I-type | if rs==rt: PC = PC+offset |
| JUMP        | 1000   | J-type | PC = address              |
| HALT        | 1111   | -      | Stop execution            |

**Register File:**
| Register | Encoding | Description |
|----------|----------|-------------|
| R0       | 00       | Always 0    |
| R1       | 01       | General purpose |
| R2       | 10       | General purpose |
| R3       | 11       | General purpose |

---

## Pipeline Architecture

```
┌────┐    ┌────┐   ┌────┐    ┌─────┐   ┌────┐
│ IF │──▶│ ID │──▶│ EX │──▶│ MEM │──▶│ WB │
└────┘    └────┘   └────┘    └─────┘   └────┘
                     ▲                   │
                     │    MEM/WB→EX      │
                     └───────────────────┘
                     ▲          │
                     │ EX/MEM→EX│
                     └──────────┘
```

**Forwarding Paths:**
- EX/MEM → EX (resolves 1-cycle RAW hazard)
- MEM/WB → EX (resolves 2-cycle RAW hazard)

**Stalling:**
- Only stalls for unavoidable LOAD-USE hazards (1 cycle)

---

## Project Structure

```
simple8-pipelined-processor/
├── src/                          # RTL source files
│   ├── pipeline_cpu.v            # Top-level pipeline integration
│   ├── if_stage.v                # Instruction Fetch stage
│   ├── id_stage.v                # Instruction Decode stage
│   ├── ex_stage.v                # Execute stage (ALU + forwarding muxes)
│   ├── mem_stage.v               # Memory Access stage
│   ├── wb_stage.v                # Writeback stage
│   ├── if_id_register.v          # IF/ID pipeline register
│   ├── id_ex_register.v          # ID/EX pipeline register
│   ├── ex_mem_register.v         # EX/MEM pipeline register
│   ├── mem_wb_register.v         # MEM/WB pipeline register
│   ├── forwarding_unit.v         # Data forwarding unit
│   ├── hazard_detection_unit.v   # Hazard detection unit
│   ├── alu.v                     # Arithmetic Logic Unit
│   ├── control_unit.v            # Control signal generator
│   ├── register_file.v           # 4x8-bit register file
│   ├── instruction_memory.v      # Instruction memory (combinational)
│   ├── data_memory.v             # Data memory
│   ├── definitions.v             # Opcode and constant definitions
│   ├── program_counter.v         # Program counter
│   ├── simple8_cpu.v             # Single-cycle CPU (reference)
│   └── basys3_top.v              # Basys3 FPGA top-level wrapper
│
├── sim/                          # Simulation files
│   ├── pipeline_cpu_tb.v         # Main testbench
│   └── instruction_memory_sim.v  # Simulation instruction memory
│
├── constraints/                  # FPGA constraints
│   └── basys3.xdc                # Pin assignments for Basys3
│
└── README.md
```

---

## Test Results

| Test | Description            | Program                          | Expected Result       | Status  |
|------|------------------------|----------------------------------|-----------------------|---------|
| 1    | Basic ALU Operations   | LOADI, LOADI, ADD                | R1=5, R2=9, R3=14    | PASS ✅  |
| 2    | LOAD/STORE + Forwarding| LOADI, STORE, LOAD, ADD          | R1=5, R2=5, R3=5     | PASS ✅  |
| 3    | Data Forwarding        | LOADI, ADD, ADD (back-to-back)   | R1=5, R2=10, R3=15   | PASS ✅  |
| 4    | LOAD-USE Hazard        | LOADI, STORE, LOAD, ADD          | R1=10, R2=10, R3=20  | PASS ✅  |

**Test 3 highlights:**
- 0 stalls (all dependencies resolved by forwarding)
- Forwarding active on consecutive ADD instructions

**Test 4 highlights:**
- 1 stall (unavoidable LOAD-USE hazard)
- All other hazards resolved by forwarding

---

## Tools Used

| Tool              | Version   | Purpose                        |
|-------------------|-----------|--------------------------------|
| SystemVerilog     | -         | RTL Design Language            |
| Xilinx Vivado     | 2025.2    | Synthesis, Implementation, Sim |
| Basys3 FPGA       | Artix-7   | Hardware Deployment            |

---

## How to Run Simulation

1. Open **Xilinx Vivado**
2. Create a new project
3. Add all files from `src/` as **Design Sources**
4. Add files from `sim/` as **Simulation Sources**
5. Set `pipeline_cpu_tb` as simulation top module
6. Select test number in `instruction_memory_sim.v`:
   ```systemverilog
   parameter TEST_SELECT = 1;  // Change to 1, 2, 3, or 4
   ```
7. Update matching test number in `pipeline_cpu_tb.v`:
   ```systemverilog
   parameter TEST_NUM = 1;  // Must match TEST_SELECT
   ```
8. Click **Run Simulation** → **Run Behavioral Simulation**

---

## How to Run on Hardware (Basys3)

1. Open **Xilinx Vivado**
2. Add all files from `src/` as **Design Sources**
3. Add `constraints/basys3.xdc` as **Constraints**
4. Set `basys3_top` as top module
5. Run **Synthesis** → **Implementation** → **Generate Bitstream**
6. Connect Basys3 via USB
7. Click **Open Hardware Manager** → **Program Device**

---

## Basys3 Board Controls

| Control       | Function                                      |
|---------------|-----------------------------------------------|
| btnC          | Reset (restarts program)                      |
| btnU          | Manual clock step (when SW[15] = ON)          |
| SW[15]        | OFF = Auto clock, ON = Manual step            |
| SW[14:12]     | Clock speed: 000=1Hz, 011=10Hz, 111=10KHz    |
| 7-Segment     | Displays R3, R2, R1, R0 values (left to right)|
| LED[15]       | Heartbeat (blinks to show board is alive)     |
| LED[14]       | Register writeback indicator                  |
| LED[12]       | HALT signal (ON when program finishes)        |
| LED[11]       | Stall indicator                               |
| LED[10:8]     | Program Counter (lower 3 bits)                |
| LED[7:6]      | Forward A control signal                      |
| LED[5:4]      | Forward B control signal                      |
| LED[3:0]      | Current opcode in ID stage                    |

---

## Hardware Demo (Test 3)

After programming the board with Test 3, the 7-segment display shows:

```
Initial:       0 0 0 0   (after reset)
After LOADI:   0 0 5 0   (R1 = 5)
After ADD R2:  0 A 5 0   (R2 = 10, shown as 'A' in hex)
Final:         F A 5 0   (R3 = 15, shown as 'F' in hex)
```

LEDs [7:4] light up during forwarding operations!

---

## Key Design Decisions

1. **Register file writes on posedge clk** - Ensures correct timing in hardware
2. **Combinational instruction memory** - Synthesizes correctly on FPGA
3. **STORE reads from rd field** - STORE source register is in rd, not rt
4. **Forwarding checks both rd and rt** - Handles STORE forwarding correctly
5. **Only stalls for LOAD-USE** - All other hazards resolved by forwarding

---
