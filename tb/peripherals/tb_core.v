`timescale 1ns / 1ps

module tb_core();

    reg clk_i_0 = 0;
    reg rst_ni_0 = 0;
    reg UART_0_rxd = 1; 
    wire UART_0_txd;
    

    wire [31:0] gpio_rtl_0_tri_io;
    wire iic_rtl_0_scl_io;
    wire iic_rtl_0_sda_io;
    wire spi_rtl_0_io0_io;
    wire spi_rtl_0_io1_io;
    wire spi_rtl_0_io2_io;
    wire spi_rtl_0_io3_io;
    wire [0:0] spi_rtl_0_ss_io;

  
 

    always #5 clk_i_0 = ~clk_i_0;


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

  
    initial begin
     
        rst_ni_0 = 0; 
        #100;
        
       
        rst_ni_0 = 1;
        $display("Sistem resetten çıktı...");

        // Buraya test senaryoları
        #1000;
        
        $display("Simülasyon tamamlandı.");
        $finish;
    end

endmodule
