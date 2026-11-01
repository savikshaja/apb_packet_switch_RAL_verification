// ----------  RO registers ----------
class ro_seq extends uvm_sequence #(apb_transaction);
  `uvm_object_utils(ro_seq)
  reg_block regmodel;
  function new(string name="ro_seq"); super.new(name); endfunction

  task body();
    uvm_status_e status;
    bit [31:0] rdata;
    uvm_reg r[10];
    bit [31:0] exp[10];

    // the 10 RO registers and the value each one must hold after reset
    r   = '{regmodel.device_id_reg, regmodel.version_reg, regmodel.switch_status_reg,
            regmodel.port_status_reg, regmodel.gen_status_reg, regmodel.stat_rx_reg,
            regmodel.stat_tx_reg, regmodel.stat_drop_reg, regmodel.err_count_reg,
            regmodel.err_info_reg};
    exp = '{32'h02A55357, 32'h00010200, 32'h000000F9, 32'h0, 32'h0,
            32'h0, 32'h0, 32'h0, 32'h0, 32'h0};

    // step 0: bring DUT and model to the power-up state
    regmodel.soft_reset_reg.write(status, 32'h1);   // DUT soft reset
    regmodel.reset();                               // model reset (notebook only)

    foreach(r[i]) begin
      // step 1: read, value must match the spec reset value
      r[i].read(status, rdata);
      if(rdata !== exp[i]) `uvm_error("RO", $sformatf("%s: expected %0h got %0h", r[i].get_name(), exp[i], rdata))
      // step 2: try to overwrite it
      r[i].write(status, ~exp[i]);
      // step 3: read again, value must be unchanged
      r[i].read(status, rdata);
      if(rdata !== exp[i]) 
	`uvm_error("RO", $sformatf("%s changed after write: got %0h", r[i].get_name(), rdata))
      else 
	`uvm_info("RO", $sformatf("%s PASSED (%0h)", r[i].get_name(), rdata), UVM_LOW)
    end
  endtask
endclass

// ----------  RW lockable registers ----------
class rw_seq extends uvm_sequence #(apb_transaction);
  `uvm_object_utils(rw_seq)
  reg_block regmodel;
  function new(string name="rw_seq"); super.new(name); endfunction

  task body();
    uvm_status_e status;
    bit [31:0] rdata, w;
    uvm_reg r[6];
    bit [31:0] mask[6], rst[6];

    // the 6 registers, their implemented bits (mask) and their reset values
    r    = '{regmodel.port_enable_reg, regmodel.fwd_enable_reg, regmodel.gen_interval_reg,
             regmodel.gen_count_reg, regmodel.irq_enable_reg, regmodel.err_enable_reg};
    mask = '{32'hF, 32'hF, 32'hFFFF, 32'hFFFF, 32'hFF, 32'hFF};
    rst  = '{32'hF, 32'hF, 32'h2, 32'h4, 32'h0, 32'h0};

    //  known starting state
    regmodel.soft_reset_reg.write(status, 32'h1);
    regmodel.reset();

    foreach(r[i]) begin
      // LOCKED, write must be ignored
      regmodel.lock_reg.write(status, 32'h0);              // lock
      w = ~rst[i] & mask[i];                               // a value different from reset
      r[i].write(status, w);
      r[i].read(status, rdata);
      if(rdata !== rst[i]) `uvm_error("RW", $sformatf("%s: locked write changed it, got %0h", r[i].get_name(), rdata))

      //  UNLOCKED, write must stick (reserved bits dropped)
      regmodel.lock_reg.write(status, 32'hA5A5C3C3);       // unlock
      w = $urandom;                                        // full 32-bit random value
      r[i].write(status, w);
      r[i].read(status, rdata);
      if(rdata !== (w & mask[i])) `uvm_error("RW", $sformatf("%s: expected %0h got %0h", r[i].get_name(), w & mask[i], rdata))
      else `uvm_info("RW", $sformatf("%s PASSED (%0h)", r[i].get_name(), rdata), UVM_LOW)

      //  model (notebook) must agree with the DUT
      r[i].mirror(status, UVM_CHECK);
    end
  endtask
endclass

//----------------LOCK -----------------------------
class lock_seq extends uvm_sequence #(apb_transaction);
  `uvm_object_utils(lock_seq)
  reg_block regmodel;
  function new(string name="lock_seq"); super.new(name); endfunction
  task body();
    uvm_status_e status;
    bit [31:0] rdata;
    bit [31:0] bad[5];
 
    regmodel.soft_reset_reg.write(status, 32'h1);
    regmodel.reset();
    // reset the block is locked (LOCKED=1)
    regmodel.lock_reg.read(status, rdata);
    if(rdata !== 32'h1) `uvm_error("LOCK", $sformatf("after reset expected 1 got %0h", rdata))
    // key unlocks (LOCKED=0, and the key is never read back)
    regmodel.lock_reg.write(status, 32'hA5A5C3C3);
    regmodel.lock_reg.read(status, rdata);
    if(rdata !== 32'h0) `uvm_error("LOCK", $sformatf("after key expected 0 got %0h", rdata))
    else `uvm_info("LOCK", "key unlocks: PASSED", UVM_LOW)
    // other value locks, including the key with one bit flipped
      regmodel.lock_reg.write(status, 32'hA5A5C3C3);   // unlock first
      regmodel.lock_reg.write(status, 32'hFFFFFFFF);         // try a wrong value
      regmodel.lock_reg.read(status, rdata);
      if(rdata !== 32'h1) `uvm_error("LOCK", $sformatf("value %0h should lock, read %0h", 32'hFFFFFFFF, rdata))
      else `uvm_info("LOCK", $sformatf("value %0h locks: PASSED", 32'hFFFFFFFF), UVM_LOW)
  endtask
endclass

// ---------- GEN_PKT_CFG ----------
class gen_pkt_cfg_seq extends uvm_sequence #(apb_transaction);
  `uvm_object_utils(gen_pkt_cfg_seq)
  reg_block regmodel;
  function new(string name="gen_pkt_cfg_seq"); super.new(name); endfunction
  task body();
    uvm_status_e status;
    bit [31:0] rdata;
    bit [31:0] wv[4], ex[4];
    //      normal value      all ones (reserved)  length = 0          length = 32 (>16)
    wv = '{32'h00AB0B02,     32'hFFFFFFFF,        32'h00120002,       32'h00002001};
    ex = '{32'h00AB0B02,     32'h00FFFF0F,        32'h00120102,       32'h00002001};
    regmodel.soft_reset_reg.write(status, 32'h1);
    regmodel.reset();
    // reset value
    regmodel.gen_pkt_cfg_reg.read(status, rdata);
    if(rdata !== 32'h401) `uvm_error("CFG", $sformatf("reset expected 401 got %0h", rdata))
    // locked write ignored
    regmodel.gen_pkt_cfg_reg.write(status, 32'h00FFFF0F);
    regmodel.gen_pkt_cfg_reg.read(status, rdata);
    if(rdata !== 32'h401) `uvm_error("CFG", $sformatf("locked write changed it: %0h", rdata))
    // unlocked: mask, length 0 -> 1, length > 16 stays readable
    regmodel.lock_reg.write(status, 32'hA5A5C3C3);
    foreach(wv[i]) begin
      regmodel.gen_pkt_cfg_reg.write(status, wv[i]);
      regmodel.gen_pkt_cfg_reg.read(status, rdata);
      if(rdata !== ex[i]) `uvm_error("CFG", $sformatf("wrote %0h expected %0h got %0h", wv[i], ex[i], rdata))
      else `uvm_info("CFG", $sformatf("wrote %0h read %0h: PASSED", wv[i], rdata), UVM_LOW)
    end
  endtask
endclass

// ---------- SWITCH_CTRL ----------
class switch_ctrl_seq extends uvm_sequence #(apb_transaction);
  `uvm_object_utils(switch_ctrl_seq)
  reg_block regmodel;
  function new(string name="switch_ctrl_seq"); super.new(name); endfunction
  task body();
    uvm_status_e status;
    bit [31:0] rdata;
    bit [31:0] wv[5], ex[5];
    //      enable+irq   reserved bit   with STAT_CLEAR   all ones     STAT_CLEAR only
    wv = '{32'h9,        32'h4,         32'hB,            32'hFFFFFFFF, 32'h2};
    ex = '{32'h9,        32'h0,         32'h9,            32'h9,        32'h0};
    regmodel.soft_reset_reg.write(status, 32'h1);
    regmodel.reset();
    regmodel.lock_reg.write(status, 32'hA5A5C3C3);          // unlock
    foreach(wv[i]) begin
      regmodel.switch_ctrl_reg.write(status, wv[i]);
      regmodel.switch_ctrl_reg.read(status, rdata);
      if(rdata !== ex[i]) `uvm_error("SWC", $sformatf("wrote %0h expected %0h got %0h", wv[i], ex[i], rdata))
      else `uvm_info("SWC", $sformatf("wrote %0h read %0h: PASSED", wv[i], rdata), UVM_LOW)
    end
    // SWITCH_STATUS must mirror the control bits: READY=1, SWITCH_ENABLED=1, LOCKED=0, ports=F -> F5
    regmodel.switch_ctrl_reg.write(status, 32'h9);
    regmodel.switch_status_reg.read(status, rdata);
    if(rdata !== 32'hF5) `uvm_error("SWC", $sformatf("SWITCH_STATUS expected F5 got %0h", rdata))
    // locked write ignored
    regmodel.lock_reg.write(status, 32'h0);                 // lock
    regmodel.switch_ctrl_reg.write(status, 32'h0);
    regmodel.switch_ctrl_reg.read(status, rdata);
    if(rdata !== 32'h9) `uvm_error("SWC", $sformatf("locked write changed it: %0h", rdata))
  endtask
endclass

// ---------- GEN_CTRL ----------
class gen_ctrl_seq extends uvm_sequence #(apb_transaction);
  `uvm_object_utils(gen_ctrl_seq)
  reg_block regmodel;
  function new(string name="gen_ctrl_seq"); super.new(name); endfunction
  task body();
    uvm_status_e status;
    bit [31:0] rdata;
    regmodel.soft_reset_reg.write(status, 32'h1);
    regmodel.reset();
    regmodel.lock_reg.write(status, 32'hA5A5C3C3);          // unlock
    // reserved bits dropped, no START/STOP bits set
    regmodel.gen_ctrl_reg.write(status, 32'hFFFFFFF9);
    regmodel.gen_ctrl_reg.read(status, rdata);
    if(rdata !== 32'h9) `uvm_error("GCTL", $sformatf("expected 9 got %0h", rdata))
    // clear everything
    regmodel.gen_ctrl_reg.write(status, 32'h0);
    regmodel.gen_ctrl_reg.read(status, rdata);
    if(rdata !== 32'h0) `uvm_error("GCTL", $sformatf("expected 0 got %0h", rdata))
    // ENABLE + START in one write: START is a pulse, so it reads back 0
    regmodel.gen_ctrl_reg.write(status, 32'h3);
    regmodel.gen_ctrl_reg.read(status, rdata);
    if(rdata !== 32'h1) `uvm_error("GCTL", $sformatf("START must not be stored: expected 1 got %0h", rdata))
    else `uvm_info("GCTL", "START pulse reads back 0: PASSED", UVM_LOW)
    regmodel.gen_ctrl_reg.write(status, 32'h0);             // disable: generator returns to IDLE
    // locked write ignored
    regmodel.lock_reg.write(status, 32'h0);
    regmodel.gen_ctrl_reg.write(status, 32'h1);
    regmodel.gen_ctrl_reg.read(status, rdata);
    if(rdata !== 32'h0) `uvm_error("GCTL", $sformatf("locked write changed it: %0h", rdata))
  endtask
endclass

// ---------- IRQ_FORCE (WO) + IRQ_STATUS (W1C) ----------
class irq_seq extends uvm_sequence #(apb_transaction);
  `uvm_object_utils(irq_seq)
  reg_block regmodel;
  function new(string name="irq_seq"); super.new(name); endfunction
  task body();
    uvm_status_e status;
    bit [31:0] rdata;
    bit [31:0] wv[4], ex[4];
    //      write 0 (no effect)  clear bit7   clear bit0   clear all
    wv = '{32'h00,              32'h80,      32'h01,     32'hFF};
    ex = '{32'hFF,              32'h7F,      32'h7E,     32'h00};
    regmodel.soft_reset_reg.write(status, 32'h1);
    regmodel.reset();
    // WO register reads 0
    regmodel.irq_force_reg.read(status, rdata);
    if(rdata !== 32'h0) `uvm_error("IRQ", $sformatf("IRQ_FORCE read expected 0 got %0h", rdata))
    // force sets the status bits (upper reserved bits ignored)
    regmodel.irq_force_reg.write(status, 32'hFFFFFFFF);
    regmodel.irq_status_reg.read(status, rdata);
    if(rdata !== 32'hFF) `uvm_error("IRQ", $sformatf("after force expected FF got %0h", rdata))
    // W1C: 0 does nothing, 1 clears only that bit
    foreach(wv[i]) begin
      regmodel.irq_status_reg.write(status, wv[i]);
      regmodel.irq_status_reg.read(status, rdata);
      if(rdata !== ex[i]) `uvm_error("IRQ", $sformatf("wrote %0h expected %0h got %0h", wv[i], ex[i], rdata))
      else `uvm_info("IRQ", $sformatf("W1C write %0h -> %0h: PASSED", wv[i], rdata), UVM_LOW)
    end
    //  forcing 0 has no effect
    regmodel.irq_force_reg.write(status, 32'h0);
    regmodel.irq_status_reg.read(status, rdata);
    if(rdata !== 32'h0) `uvm_error("IRQ", $sformatf("force 0 changed status: %0h", rdata))
  endtask
endclass

class err_seq extends uvm_sequence #(apb_transaction);
  `uvm_object_utils(err_seq)
  reg_block regmodel;
  function new(string name="err_seq"); super.new(name); endfunction
  task body();
    uvm_status_e status;
    bit [31:0] rdata;
    regmodel.soft_reset_reg.write(status, 32'h1);
    regmodel.reset();
    // WO register reads 0
    regmodel.err_inject_reg.read(status, rdata);
    if(rdata !== 32'h0) `uvm_error("ERR", $sformatf("ERR_INJECT read expected 0 got %0h", rdata))
    //  inject DEST error (bit 1): status = bit1 + INJECTED(bit7), count = 1
    regmodel.err_inject_reg.write(status, 32'h2);
    regmodel.err_status_reg.read(status, rdata);
    if(rdata !== 32'h82) `uvm_error("ERR", $sformatf("ERR_STATUS expected 82 got %0h", rdata))
    regmodel.err_count_reg.read(status, rdata);
    if(rdata !== 32'h1) `uvm_error("ERR", $sformatf("ERR_COUNT expected 1 got %0h", rdata))
    regmodel.err_info_reg.read(status, rdata);              // dest=1, source=1 (injected), code=1
    if(rdata !== 32'h00010101) `uvm_error("ERR", $sformatf("ERR_INFO expected 10101 got %0h", rdata))
    // W1C: writing 0 does nothing, writing 1 clears only that bit
    regmodel.err_status_reg.write(status, 32'h0);
    regmodel.err_status_reg.read(status, rdata);
    if(rdata !== 32'h82) `uvm_error("ERR", $sformatf("write 0 changed status: %0h", rdata))
    regmodel.err_status_reg.write(status, 32'h2);
    regmodel.err_status_reg.read(status, rdata);
    if(rdata !== 32'h80) `uvm_error("ERR", $sformatf("clearing bit1 expected 80 got %0h", rdata))
    // CLEAR_COUNT (bit 31) has priority over an injection in the same write
    regmodel.err_inject_reg.write(status, 32'h80000001);
    regmodel.err_count_reg.read(status, rdata);
    if(rdata !== 32'h0) `uvm_error("ERR", $sformatf("ERR_COUNT expected 0 got %0h", rdata))
    else `uvm_info("ERR", "err_seq PASSED", UVM_LOW)
  endtask
endclass

// ---------- SOFT_RESET (WO) ----------
class soft_rst_seq extends uvm_sequence #(apb_transaction);
  `uvm_object_utils(soft_rst_seq)
  reg_block regmodel;
  function new(string name="soft_rst_seq"); super.new(name); endfunction
  task body();
    uvm_status_e status;
    bit [31:0] rdata;
    regmodel.soft_reset_reg.write(status, 32'h1);
    regmodel.reset();
    // unlock and move a few registers away from their defaults
    regmodel.lock_reg.write(status, 32'hA5A5C3C3);
    regmodel.port_enable_reg.write(status, 32'h5);
    regmodel.gen_count_reg.write(status, 32'h9);
    regmodel.err_inject_reg.write(status, 32'h1);           // an error now exists
    // writing 0 must do nothing
    regmodel.soft_reset_reg.write(status, 32'h0);
    regmodel.port_enable_reg.read(status, rdata);
    if(rdata !== 32'h5) `uvm_error("SRST", $sformatf("write 0 changed PORT_ENABLE: %0h", rdata))
    // writing 1 restores the defaults
    regmodel.soft_reset_reg.write(status, 32'h1);
    regmodel.reset();
    regmodel.port_enable_reg.read(status, rdata);
    if(rdata !== 32'hF) `uvm_error("SRST", $sformatf("PORT_ENABLE expected F got %0h", rdata))
    regmodel.gen_count_reg.read(status, rdata);
    if(rdata !== 32'h4) `uvm_error("SRST", $sformatf("GEN_COUNT expected 4 got %0h", rdata))
    regmodel.lock_reg.read(status, rdata);                  // soft reset locks the block again
    if(rdata !== 32'h1) `uvm_error("SRST", $sformatf("LOCK expected 1 got %0h", rdata))
    regmodel.err_status_reg.read(status, rdata);
    if(rdata !== 32'h0) `uvm_error("SRST", $sformatf("ERR_STATUS expected 0 got %0h", rdata))
    regmodel.err_count_reg.read(status, rdata);
    if(rdata !== 32'h0) `uvm_error("SRST", $sformatf("ERR_COUNT expected 0 got %0h", rdata))
    regmodel.soft_reset_reg.read(status, rdata);            // WO register reads 0
    if(rdata !== 32'h0) `uvm_error("SRST", $sformatf("SOFT_RESET read expected 0 got %0h", rdata))
    else `uvm_info("SRST", "soft reset PASSED", UVM_LOW)
  endtask
endclass
