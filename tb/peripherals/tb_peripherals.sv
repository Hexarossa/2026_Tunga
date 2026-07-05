`timescale 1ns / 1ps

module tb_peripherals();

    logic clk = 0;
    logic rst_n = 0;

    logic jtag_tck = 0;
    logic jtag_tms = 1;
    logic jtag_trst_n = 0;
    logic jtag_tdi = 0;
    logic jtag_tdo;
    logic jtag_tdo_oe;

    logic uart_rx = 1;
    logic uart_tx;
    logic uart_stream_rx = 1;
    logic uart_stream_tx;

    wire i2c_scl;
    wire i2c_sda;
    assign (weak1, weak0) i2c_scl = 1'b1;
    assign (weak1, weak0) i2c_sda = 1'b1;

    wire [15:0] gpio_pins;
    logic [15:0] gpio_tb_driver = 16'hZZZZ;
    assign gpio_pins = gpio_tb_driver;

    wire qspi_cs;
    wire qspi_sclk;
    wire [3:0] qspi_dq;

    always #5 clk = ~clk;

    gozlem_design_2_wrapper dut (
        .clk_i_0          (clk),
        .rst_ni_0         (rst_n),
        
        .jtag_tck_i_0     (jtag_tck),
        .jtag_tms_i_0     (jtag_tms),
        .jtag_trst_ni_0   (jtag_trst_n),
        .jtag_tdi_i_0     (jtag_tdi),
        .jtag_tdo_o_0     (jtag_tdo),
        .jtag_tdo_oe_o_0  (jtag_tdo_oe),
        
        .uart_rxd_0       (uart_rx),
        .uart_txd_0       (uart_tx),
        
        .uart_rxd_1       (uart_stream_rx),
        .uart_txd_1       (uart_stream_tx),
        
        .scl_0            (i2c_scl),
        .sda_0            (i2c_sda),
        
        .gpio_i_0         (gpio_pins),
        .gpio_o_0         (),
        .gpio_tx_en_o_0   (),
        
        .CS_pad_1         (qspi_cs),
        .SCLK_pad_1       (qspi_sclk),
        .dq_pad_1         (qspi_dq)
    );

    initial begin
        $display("[SYSTEM_TB] Basladi");
        
        rst_n = 0;
        #200;
        rst_n = 1;
        #100;
        $display("[SYSTEM_TB] Reset kaldirildi.");

        $display("[SYSTEM_TB] TEST: GPIO Harici Pin ");
        gpio_tb_driver = 16'h5555;
        #50;
        gpio_tb_driver = 16'hAAAA;
        #50;
        gpio_tb_driver = 16'hZZZZ; 

        $display("[SYSTEM_TB] TEST: UART Hat Durumlari ");
        uart_rx = 0; #8680; 
        uart_rx = 1; #2000;
        
        uart_stream_rx = 0; #8680;
        uart_stream_rx = 1; #5000;

        $display("[SYSTEM_TB] TEST: I2C ve QSPI ");
        #500;

        $display("[SYSTEM_TB] BAŞARILI");
        $finish;
    end

endmodule
