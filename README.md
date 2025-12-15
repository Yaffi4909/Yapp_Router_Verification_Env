# YAPP Router Verification Environment (UVM)

## Overview
This repository contains a complete **UVM-based verification environment** for the **YAPP Router**, developed as part of the **Qualcomm–KamaTech Verification Bootcamp**.

The environment verifies correct packet routing, register behavior, and multi-channel functionality using industry-standard **SystemVerilog UVM methodology**.

The repository reflects the **final integrated stage (Lab 11B)**, including full environment integration with the **UVM Register Model (RAL)**.

---

## Environment Architecture
The verification environment includes:

- **YAPP UVC** – packet-level stimulus and monitoring  
- **HBUS UVC** – register access and configuration  
- **Channel UVCs** – output channel monitoring  
- **Clock & Reset Agent**
- **Scoreboard** with reference model
- **Functional Coverage**
- **UVM Register Model (RAL)** with frontdoor and backdoor access
- **Multi-channel sequencer integration**

---

## Repository Structure

Yapp_Router_Verification_Env/
├── yapp/ # YAPP UVC (driver, monitor, sequencer, sequences)
├── hbus/ # HBUS UVC
├── channel/ # Channel UVCs
├── clock_and_reset/ # Clock & Reset agent
├── router_rtl/ # DUT RTL
├── reg_verifier_dir/ # Register model files
├── test_install/ # Test setup and run files
├── README.md

> Note: Simulator-generated directories (e.g. `xcelium.d`) and temporary files are intentionally excluded.

---

## Register Model (Lab 11A + 11B)
The environment integrates a **UVM Register Abstraction Layer (RAL)**:

- Auto-generated register model
- Adapter-based connection to HBUS
- Frontdoor and backdoor access
- Automatic prediction enabled
- Integrated with the main sequencer

---

## Verification Features
- End-to-end packet routing verification
- Register read/write verification
- Multi-channel traffic support
- Scoreboard-based checking
- Functional coverage
- Modular and reusable UVC architecture

---

## Tools & Technologies
- **SystemVerilog**
- **UVM**
- **Cadence Xcelium**
- **UVM Register Layer (RAL)**

---

## Notes
This repository represents the **final verified state** of the project.
Intermediate lab stages and simulator artifacts were intentionally removed to present a clean, production-quality verification environment.

---

## Author
Developed by **Yaffi Yud**  
Qualcomm–KamaTech Verification Bootcamp

