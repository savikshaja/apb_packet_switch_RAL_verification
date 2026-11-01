# APB Packet Switch – UVM RAL Verification

## Project Overview

This project focuses on verifying an APB Packet Switch using SystemVerilog and UVM Register Abstraction Layer (RAL).

The UVM RAL model is used to access and verify DUT registers through the APB interface. Different test cases are developed to verify register access, configuration, locking, packet generator control, interrupt handling, error handling, and software reset functionality.

## Directory Structure

```text
apb_packet_switch_RAL_verification/
│
├── src/
│   ├── design/
│   │   ├── apb_pkt_pkg.sv
│   │   ├── apb_pkt_switch.sv
│   │   ├── pkt_generator.sv
│   │   └── pkt_switch.sv
│   │
│   └── testbench/
│       ├── apb_registers/
│       │
│       ├── Makefile
│       ├── apb_adapter.sv
│       ├── apb_agent.sv
│       ├── apb_driver.sv
│       ├── apb_env.sv
│       ├── apb_interface.sv
│       ├── apb_monitor.sv
│       ├── apb_pkg.sv
│       ├── apb_sequencer.sv
│       ├── apb_subscriber.sv
│       ├── apb_transaction.sv
│       ├── tb.sv
│       ├── test.sv
│       └── top_reg_seq.sv
│
└── README.md
```

## Verification Environment

The testbench consists of the following components:

- **APB Interface:** Connects the testbench to the DUT.
- **APB Agent:** Contains the driver, monitor, and sequencer.
- **APB Driver:** Drives APB read and write transactions.
- **APB Monitor:** Monitors APB transactions.
- **APB Sequencer:** Provides transactions to the driver.
- **RAL Model:** Defines the DUT registers and their configurations.
- **APB Adapter:** Converts UVM register transactions into APB transactions.
- **Environment:** Instantiates and connects the verification components.
- **Sequences:** Perform register read and write operations.
- **Tests:** Execute different register verification scenarios.

## Test Cases

| Test Name | Description |
|---|---|
| `ro_test` | Verifies read-only register access. |
| `rw_test` | Verifies read and write operations. |
| `lock_test` | Verifies register locking and unlocking. |
| `gen_pkt_cfg_test` | Verifies packet generator configuration. |
| `switch_ctrl_test` | Verifies switch control functionality. |
| `gen_ctrl_test` | Verifies packet generator control. |
| `irq_test` | Verifies interrupt register functionality. |
| `err_test` | Verifies error register functionality. |
| `soft_rst_test` | Verifies software reset functionality. |

## Test Execution

Each test is derived from the common `apb_base_test`.

The base test creates the UVM environment. Individual tests create their respective sequences, connect the RAL model to the sequence, and start the sequence on the APB agent sequencer.

Tests can be selected using the UVM test name:

```bash
+UVM_TESTNAME=ro_test
+UVM_TESTNAME=rw_test
+UVM_TESTNAME=lock_test
+UVM_TESTNAME=gen_pkt_cfg_test
+UVM_TESTNAME=switch_ctrl_test
+UVM_TESTNAME=gen_ctrl_test
+UVM_TESTNAME=irq_test
+UVM_TESTNAME=err_test
+UVM_TESTNAME=soft_rst_test
```

## Tools and Technologies

- SystemVerilog
- UVM
- UVM Register Abstraction Layer (RAL)
- APB Protocol
- Synopsys VCS / QuestaSim

## Project Objective

The objective of this project is to understand and implement register-level verification using UVM RAL and verify APB Packet Switch functionality through frontdoor APB register accesses.
