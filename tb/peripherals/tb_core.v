`timescale 1ns / 1ps

module tb_core();

    // --- 1. Sinyal Tanımlamaları ---
    reg clk_i_0 = 0;
    reg rst_ni_0 = 0;
    reg UART_0_rxd = 1; // Boşta (idle) durumunda UART girişi genellikle 1'dir
    wire UART_0_txd;
    
    // Inout portlar için (GPIO, I2C, SPI)
    wire [31:0] gpio_rtl_0_tri_io;
    wire iic_rtl_0_scl_io;
    wire iic_rtl_0_sda_io;
    wire spi_rtl_0_io0_io;
    wire spi_rtl_0_io1_io;
    wire spi_rtl_0_io2_io;
    wire spi_rtl_0_io3_io;
    wire [0:0] spi_rtl_0_ss_io;

    // Diğer SPI sinyalleri
 

    // --- 2. Saat Üretimi (Clock Generation) ---
    // 100MHz bir saat sinyali için (10ns periyot) ⚡
    always #5 clk_i_0 = ~clk_i_0;

    // --- 3. Tasarımın Bağlanması (UUT Instantiation) ---
    gozlem_design_2_wrapper uut (
        .UART_0_rxd(UART_0_rxd),
        .UART_0_txd(UART_0_txd),
        .clk_i_0(clk_i_0),
        .gpio_rtl_0_tri_io(gpio_rtl_0_tri_io),
        .iic_rtl_0_scl_io(iic_rtl_0_scl_io),
        .iic_rtl_0_sda_io(iic_rtl_0_sda_io),
        .rst_ni_0(rst_ni_0),
    
        .spi_rtl_0_io0_io(spi_rtl_0_io0_io),
        .spi_rtl_0_io1_io(spi_rtl_0_io1_io),
        .spi_rtl_0_io2_io(spi_rtl_0_io2_io),
        .spi_rtl_0_io3_io(spi_rtl_0_io3_io),
        .spi_rtl_0_ss_io(spi_rtl_0_ss_io)
    );

    // --- 4. Test Senaryosu ---
    initial begin
        // Sistem başlangıç durumu
        rst_ni_0 = 0; // Reset aktif (Low-active)
        #100;
        
        // Reseti kaldırıyoruz
        rst_ni_0 = 1;
        $display("Sistem resetten çıktı...");

        // Buraya test senaryolarını ekleyeceğiz
        #1000;
        
        $display("Simülasyon tamamlandı.");
        $finish;
    end

endmodule