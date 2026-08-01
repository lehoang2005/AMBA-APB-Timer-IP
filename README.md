# AMBA APB Timer IP

**Author:** Lê Phạm Thái Hoàng  

## 📝 Project Overview
This project focuses on the **Design and Verification of an Advanced APB Timer IP** using Verilog. The timer features a 64-bit counter with multiple operation modes, an APB bus interface supporting wait states and error responses, and interrupt generation. The design has been verified against a reference Golden Model, achieving **100% Code Coverage**.

## ✨ Key Features
- **64-bit Count-up Timer:** Highly precise 64-bit counter with an active-low asynchronous reset.
- **Multiple Operating Modes:**
  - **Default Mode:** Normal counting speed.
  - **Control Mode:** Programmable clock divider (prescaler supporting divisions by 2 up to 256).
  - **Halt Mode:** Supports pausing the timer via debug mode hardware signal or software request (THCSR).
- **AMBA APB Interface Integration:**
  - 12-bit address bus for register access.
  - Supports 1-cycle wait state (`pready`).
  - Advanced error handling (`pslverr`) for prohibited configurations (e.g., attempting to change clock divider settings while the timer is running).
  - Supports byte strobe access (`pstrb`).
- **Interrupt Controller:** Generates interrupts (`tim_int`) when the counter matches the 64-bit compare registers (TCMP0/TCMP1) with masking support.

## 🏗️ Hardware Architecture
The IP is partitioned into 5 main sub-modules for clean RTL design:
1. **APB Slave Interface:** Handles APB bus transactions, wait states, and error responses.
2. **Registers Block:** Contains all configuration and status registers.
3. **Counter Control:** Manages the clock prescaler, counting modes, and halt logic.
4. **Counter:** The core 64-bit synchronous counter logic.
5. **Interrupt Logic:** Generates output interrupts based on match conditions and interrupt enable flags.
<img width="2048" height="947" alt="block_diagram" src="https://github.com/user-attachments/assets/a75aeaf3-30e3-409a-9a64-2ebaee24d161" />

## 📊 Register Map
| Address | Register | Description |
|---------|----------|-------------|
| `0x00`  | TCR      | Timer Control Register (Enables timer, sets divider) |
| `0x04`  | TDR0     | Timer Data Register 0 (Lower 32-bit counter data) |
| `0x08`  | TDR1     | Timer Data Register 1 (Upper 32-bit counter data) |
| `0x0C`  | TCMP0    | Timer Compare Register 0 (Lower 32-bit compare val) |
| `0x10`  | TCMP1    | Timer Compare Register 1 (Upper 32-bit compare val) |
| `0x14`  | TIER     | Timer Interrupt Enable Register |
| `0x18`  | TISR     | Timer Interrupt Status Register |
| `0x1C`  | THCSR    | Timer Halt Control Status Register |
| Others  | Reserved |  |

## 🧪 Verification & Testing
<img width="2048" height="905" alt="image" src="https://github.com/user-attachments/assets/ab8d48ef-fec0-4064-b046-b81f0761ba1d" />

The design was robustly verified using a comprehensive Verilog testbench environment.
- **Testcases:** 13/13 testcases passed, covering Register Initial/RW checks, APB Protocol (Multiple access, unaligned access, error response), Counter modes, and Interrupts.
- **Golden Model Verification:** Output data perfectly matches the provided reference Golden Model.
- **Code Coverage:** Achieved **100% coverage** (Statement, Branch, Toggle) after justified exclusions for unreachable APB protocol violations.

## 📁 Directory Structure
- `rtl/`: Contains the Verilog source code of the Timer IP.
- `tb/`: Testbench files and verification environment.
- `sim/`: Simulation scripts.
- `testcases/`: Specific testcase scenarios.

## 🛠️ Technologies & Skills
- **Hardware Description Language:** Verilog
- **Protocols:** AMBA APB
- **Domains:** RTL Design, Functional Verification, Code Coverage Analysis, Computer Architecture
