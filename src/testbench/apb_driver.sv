class apb_driver extends uvm_driver #(apb_transaction);
  `uvm_component_utils(apb_driver)
  
  apb_transaction tr;
  virtual apb_interface vif;
  
  function new(string name = "apb_driver", uvm_component parent=null);
    super.new(name,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(virtual apb_interface)::get(this,"","vif",vif))
      `uvm_error("drv","Unable to access interface");
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    vif.psel    = 0;
    vif.penable = 0;

    wait (vif.presetn == 1'b1);
//    tr=apb_transaction::type_id::create("tr");
    forever begin
      seq_item_port.get_next_item(tr);
      drive_dut(tr);
      seq_item_port.item_done();
    end
  endtask
  
  task drive_dut(apb_transaction tr);
    @(posedge vif.pclk);
    vif.paddr  <= tr.paddr;
    vif.pwrite <= tr.pwrite;
    vif.pwdata <= tr.pwdata;
    vif.psel <=1'b1;
    vif.penable <= 1'b0;
    
    @(posedge vif.pclk);
    vif.penable<=1'b1;
    do @(posedge vif.pclk);while(!vif.pready);
    tr.prdata=vif.prdata;
    tr.pslverr=vif.pslverr;
    vif.psel<=1'b0;
    vif.penable<=1'b0;      
  endtask
endclass
