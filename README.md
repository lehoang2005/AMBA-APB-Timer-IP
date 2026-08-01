# AMBA APB Timer IP — RTL-to-DFT Implementation Project

**Author:** Lê Phạm Thái Hoàng  
**HDL:** Verilog  
**Bus Interface:** AMBA APB  
**Project Direction:** RTL Design, Logic Synthesis, Static Timing Analysis and Design for Test

---

## Project Overview

This repository contains a 64-bit AMBA APB Timer IP developed as a progressive ASIC learning project.

The initial RTL design and functional verification phases establish a stable functional baseline. The project is then extended beyond RTL simulation toward:

- Logic synthesis and technology mapping
- Gate-level netlist verification
- Static Timing Analysis
- Scan architecture design
- Scan-chain insertion and verification
- Fault modeling
- ATPG experiments
- Fault simulation and test coverage analysis

The long-term objective is to demonstrate a reproducible flow from a verified RTL design to a timing-analyzed and testable gate-level implementation.

---

## Project Flow

```text
Design Specification
        │
        ▼
RTL Implementation
        │
        ▼
Functional Verification
        │
        ▼
Logic Synthesis
        │
        ▼
Gate-Level Verification
        │
        ▼
Static Timing Analysis
        │
        ▼
Scan Architecture and Scan Insertion
        │
        ▼
ATPG and Fault Simulation
        │
        ▼
DFT Coverage Analysis
```

The RTL and functional verification stages have been completed. Synthesis, STA and DFT development will be added incrementally with reproducible scripts, logs, reports and documentation.

---

## Design Specification

The Timer IP provides a memory-mapped timer peripheral connected through an AMBA APB interface.

### Timer Functions

- 64-bit count-up counter
- Active-low asynchronous reset
- Normal counting mode
- Programmable divided-counting mode
- Clock division from divide-by-2 up to divide-by-256
- Hardware timer enable and disable
- Counter reset when `timer_en` changes from high to low
- Debug-assisted halt mode
- Software halt request through `THCSR`
- Halt acknowledgement status

### AMBA APB Interface

- 12-bit APB address
- 32-bit APB write and read data
- Byte-strobe write support through `pstrb`
- One-cycle wait-state behavior
- APB slave error response for prohibited timer configurations
- Register-based configuration and status access

### Interrupt Functions

- 64-bit compare value
- Interrupt generation when the counter matches the compare value
- Interrupt enable and masking
- Latched interrupt status
- Write-one-to-clear interrupt status behavior

---

## Register Map

| Address | Register | Description |
|---|---|---|
| `0x00` | TCR | Timer Control Register |
| `0x04` | TDR0 | Lower 32 bits of the 64-bit counter |
| `0x08` | TDR1 | Upper 32 bits of the 64-bit counter |
| `0x0C` | TCMP0 | Lower 32 bits of the compare value |
| `0x10` | TCMP1 | Upper 32 bits of the compare value |
| `0x14` | TIER | Timer Interrupt Enable Register |
| `0x18` | TISR | Timer Interrupt Status Register |
| `0x1C` | THCSR | Timer Halt Control and Status Register |
| Others | Reserved | Reserved address space |

Detailed bit-field descriptions are available in the project report and will later be separated into the design documentation directory.

---

## RTL Architecture

The RTL implementation is partitioned into five main functional blocks:

1. **APB Slave Interface**  
   Generates read and write enables, inserts the wait state and reports APB access errors.

2. **Register Block**  
   Implements the control, counter-data, compare, interrupt and halt-control registers.

3. **Counter Control**  
   Handles timer enable, halt behavior, clock division and counter clear control.

4. **64-bit Counter**  
   Maintains the timer value and supports software byte writes through `TDR0` and `TDR1`.

5. **Interrupt Logic**  
   Detects compare matches and generates the timer interrupt from the interrupt-enable and status signals.

<img width="2048" height="947" alt="APB Timer block diagram" src="https://github.com/user-attachments/assets/a75aeaf3-30e3-409a-9a64-2ebaee24d161" />

This modular structure provides clear synthesis boundaries and will later support hierarchy analysis, timing-path investigation and DFT planning.

---

## RTL and Verification Baseline

The RTL and functional verification stages provide the reference behavior for all later implementation phases.

The existing verification environment covers:

- Register reset-value checking
- Register read and write operations
- APB read and write transfers
- APB wait-state behavior
- Byte-strobe accesses
- Invalid configuration error responses
- Normal counter operation
- Divided-counting modes
- Timer enable and clear behavior
- Debug and software halt behavior
- Compare-match conditions
- Interrupt enable, masking and clearing
- Multiple APB accesses

The current regression contains **13 passing testcases**. The design was also compared with the provided Golden Model.

Code coverage reached **100% after justified exclusions** for unreachable or protocol-invalid conditions. These exclusions and their reasoning are documented in the original project report.

<img width="2048" height="905" alt="APB Timer verification results" src="https://github.com/user-attachments/assets/ab8d48ef-fec0-4064-b046-b81f0761ba1d" />

The functional testbench will be reused for post-synthesis and post-DFT regression whenever the generated netlist remains simulation-compatible.

---

# ASIC Synthesis

## Objectives

The synthesis phase converts the verified Verilog RTL into a technology-mapped gate-level representation.

The synthesis study will include:

- RTL parsing and elaboration
- Top-module and source-file definition
- Synthesizability checks
- Clock and reset identification
- Combinational-loop checking
- Latch inference checking
- Technology-independent optimization
- Technology mapping
- Sequential-cell analysis
- Hierarchy preservation or flattening experiments
- Area and cell-count analysis
- Warning and unresolved-reference review
- Gate-level netlist generation
- Post-synthesis functional simulation

## Planned Synthesis Artifacts

```text
synthesis/
├── README.md
├── constraints/
├── scripts/
├── logs/
├── reports/
│   ├── hierarchy_report.txt
│   ├── cell_usage_report.txt
│   ├── area_report.txt
│   └── warning_summary.txt
├── netlist/
└── results/
```

Expected outputs include:

- Reproducible synthesis command
- Tool-version record
- Synthesized gate-level netlist
- Cell-usage report
- Area report
- Inferred-register report
- Synthesis warning review
- Post-synthesis simulation log
- Comparison against the RTL functional baseline

## Synthesis Questions to Investigate

The project will specifically examine:

- How the 64-bit counter is synthesized
- The implementation cost of the 64-bit comparator
- The area contribution of APB registers
- Logic generated for byte-strobe support
- Logic depth of the prescaler and counter-enable path
- Effects of hierarchy flattening
- Treatment of active-low asynchronous reset
- Scan eligibility of synthesized sequential elements

A synthesis phase will be considered complete only when the netlist, commands, logs and reports are reproducible from a clean environment.

---

# Static Timing Analysis

## Objectives

Static Timing Analysis will evaluate whether the synthesized design satisfies its timing requirements without relying on functional test vectors.

The STA phase will include:

- Liberty timing-library setup
- Clock definition
- Input-delay constraints
- Output-delay constraints
- Clock uncertainty
- Clock transition assumptions
- Input-driver and output-load assumptions
- Setup analysis
- Hold analysis
- Recovery and removal checks for asynchronous reset
- Critical-path identification
- Unconstrained-path detection
- Timing-exception review
- Constraint validation

## Timing Paths of Interest

The main timing paths expected to require investigation include:

- APB write inputs to configuration registers
- Configuration registers to counter-control logic
- Prescaler state to counter-enable generation
- Counter register to increment logic and back to the counter
- Counter outputs through the 64-bit compare logic
- Interrupt status to `tim_int`
- APB register-selection logic to `tim_prdata`
- Asynchronous reset recovery and removal paths

## Planned STA Artifacts

```text
sta/
├── README.md
├── constraints/
│   └── timer.sdc
├── scripts/
├── logs/
├── reports/
│   ├── setup_report.txt
│   ├── hold_report.txt
│   ├── critical_paths.txt
│   ├── unconstrained_paths.txt
│   └── constraint_check.txt
└── results/
```

Each STA result will document:

- Timing library and operating condition
- Target clock period and frequency
- Constraint assumptions
- Worst setup slack
- Worst hold slack
- Startpoint and endpoint of critical paths
- Path-group classification
- Unconstrained or incorrectly constrained paths
- Interpretation of violations
- Proposed RTL or constraint corrections

The design will not be declared timing-clean solely because the reported slack is positive. Constraint completeness must also be reviewed.

---

# Design for Test

## Objectives

The DFT phase extends the functionally verified design with structures that improve controllability and observability during manufacturing test.

The initial DFT scope focuses on scan-based testing and stuck-at fault analysis.

Planned topics include:

- Sequential-element inventory
- Scan-eligible and non-scan element classification
- Scan clock and scan-enable definition
- Scan input and scan output definition
- Scan flip-flop replacement or educational scan modeling
- Scan-chain ordering
- Scan-chain stitching
- Scan-shift operation
- Scan-capture operation
- Reset behavior in test mode
- Test-mode control of functional enables
- Clock-divider and counter considerations
- Scan-chain verification
- Stuck-at fault generation
- ATPG pattern generation
- Fault simulation
- Fault coverage calculation
- Undetected-fault analysis
- Untestable and redundant-fault classification

## Initial DFT Analysis

The design contains several structures that are relevant to scan planning:

- A 64-bit counter with active-low asynchronous reset
- APB configuration and status registers
- Compare registers
- Interrupt enable and status registers
- Timer-enable history state
- Prescaler state
- Halt acknowledgement state
- Functional control logic that may affect capture behavior

The DFT study will examine whether these elements can be included in a scan chain and whether additional test-mode controls are required.

Particular attention will be given to:

- Preventing unintended counter operation during scan shift
- Controlling the prescaler during test
- Handling asynchronous reset safely
- Preserving APB functionality outside test mode
- Making interrupt and halt logic observable
- Maintaining functional equivalence when `test_mode = 0`

## Planned Scan Interface

An educational scan version may introduce signals such as:

```verilog
input  wire test_mode;
input  wire scan_enable;
input  wire scan_in;
output wire scan_out;
```

The exact interface and scan architecture will be defined in a dedicated DFT specification before modifying the functional RTL or synthesized netlist.

## Planned DFT Artifacts

```text
dft/
├── README.md
├── specification/
├── scan/
│   ├── scripts/
│   ├── netlist/
│   ├── reports/
│   └── simulation/
├── faults/
├── atpg/
│   ├── patterns/
│   ├── logs/
│   └── reports/
└── results/
```

Expected outputs include:

- DFT architecture specification
- Sequential-cell inventory
- Scan-eligibility report
- Scan-chain configuration
- Scan-inserted netlist
- Scan-chain connectivity report
- Scan-shift testbench
- Scan-shift waveform
- Scan-capture waveform
- Functional-mode regression results
- Fault list
- ATPG pattern set
- Fault-simulation report
- Stuck-at fault coverage
- Analysis of undetected faults

---

## DFT Completion Criteria

The scan phase will be considered complete only when all of the following are demonstrated:

- The scan chain shifts known data correctly
- Captured responses can be shifted out correctly
- Functional behavior is preserved when test mode is disabled
- Reset behavior is documented in functional and scan modes
- The number of scan cells matches the reported scan-chain length
- Scan connectivity has no breaks or duplicated elements
- ATPG commands and patterns are reproducible
- Fault coverage is calculated from a documented fault model
- Undetected and untestable faults are analyzed rather than ignored

A high coverage percentage alone will not be treated as sufficient evidence without explaining the fault model, exclusions and remaining coverage gap.

---

## Repository Structure

```text
.
├── README.md
├── LICENSE
├── .gitignore
│
├── docs/
│   ├── README.md
│   ├── specification/
│   ├── architecture/
│   └── reports/
│
├── rtl/
│   ├── README.md
│   └── *.v
│
├── tb/
│   ├── README.md
│   └── *.v
│
├── testcases/
│   ├── README.md
│   └── *.v
│
├── sim/
│   ├── README.md
│   ├── scripts/
│   ├── logs/
│   └── waves/
│
├── synthesis/
│   ├── README.md
│   ├── constraints/
│   ├── scripts/
│   ├── logs/
│   ├── reports/
│   └── netlist/
│
├── sta/
│   ├── README.md
│   ├── constraints/
│   ├── scripts/
│   ├── logs/
│   └── reports/
│
├── dft/
│   ├── README.md
│   ├── specification/
│   ├── scan/
│   ├── faults/
│   ├── atpg/
│   └── reports/
│
├── scripts/
│   └── README.md
│
└── results/
    └── README.md
```

Each major directory will contain its own `README.md` describing:

- Purpose
- Required tools and versions
- Input files
- Execution commands
- Expected outputs
- Generated artifacts
- Result interpretation
- Known limitations
- Troubleshooting notes

The root README provides the project-level overview. Detailed execution instructions belong inside the relevant subdirectory.

---

## Project Status

| Phase | Status | Evidence |
|---|---|---|
| Design specification | Completed | Project report |
| RTL implementation | Completed | Verilog source files |
| Functional testbench | Completed | Testbench and testcases |
| Directed regression | Completed | 13 passing testcases |
| Golden Model comparison | Completed | Verification results |
| Code coverage analysis | Completed | Coverage report and exclusions |
| Open-source simulation migration | Planned | Pending Linux environment |
| Logic synthesis | Planned | Pending scripts and reports |
| Post-synthesis simulation | Planned | Pending gate-level netlist |
| STA constraints | Planned | Pending SDC |
| Setup timing analysis | Planned | Pending synthesis result |
| Hold timing analysis | Planned | Pending synthesis result |
| Scan architecture | Planned | Pending DFT specification |
| Scan insertion | Planned | Pending scan flow |
| Scan verification | Planned | Pending scan netlist |
| ATPG | Planned | Pending fault model |
| Fault simulation | Planned | Pending ATPG patterns |
| DFT coverage analysis | Planned | Pending fault reports |

A phase will be marked as completed only when its commands, inputs, logs, reports and interpretation are committed.

---

## Planned Open-Source Toolchain

The project will prioritize open-source and educational tools where practical.

| Activity | Candidate Tools |
|---|---|
| RTL simulation | Icarus Verilog, Verilator |
| Waveform inspection | GTKWave |
| Logic synthesis | Yosys |
| Static Timing Analysis | OpenSTA |
| Physical implementation experiments | OpenROAD |
| Gate-level simulation | Icarus Verilog or Verilator, depending on library compatibility |
| Scan and ATPG study | Educational scan flow, compatible ATPG tools and custom scripts |
| Automation | GNU Make, Bash and Python |

The exact tools and versions will be fixed only after each flow has been validated. Installation and execution instructions will be maintained in the corresponding directory README.

---

## Reproducibility Policy

Every implementation phase should provide:

- Tool name and version
- Required dependencies
- Input file list
- Single-command or clearly documented execution flow
- Configuration and constraint files
- Complete log
- Generated reports
- Expected pass criteria
- Known warnings
- Debug history
- Result interpretation

Generated reports without the commands and inputs required to reproduce them are not considered complete project evidence.

---

## Documentation

The original design and verification report is stored under:

```text
docs/reports/LEPHAMTHAIHOANG_Final_Project.pdf
```

Recommended local documentation:

- `rtl/README.md` — RTL files, hierarchy and coding assumptions
- `tb/README.md` — Testbench architecture and reusable tasks
- `testcases/README.md` — Test intent and expected results
- `sim/README.md` — Compilation, regression and waveform commands
- `synthesis/README.md` — Synthesis setup, commands and report analysis
- `sta/README.md` — Timing assumptions, constraints and STA results
- `dft/README.md` — Scan architecture, ATPG and fault-analysis methodology
- `results/README.md` — Consolidated evidence and milestone summary

---

## License

This project is licensed under the Apache License 2.0.

Copyright © 2026 Lê Phạm Thái Hoàng.

Reuse and redistribution must retain the applicable copyright and license notices.
