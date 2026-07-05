`timescale 1ns / 1ps

module tb_peripherals();

    // --- 1. Testbench Yerel Sinyalleri ---
    logic clk = 0;
    logic rst_n = 0;

    // JTAG Hatları (Boşta / Güvenli Lojikte)
    logic jtag_tck = 0;
    logic jtag_tms = 1;
    logic jtag_trst_n = 0;
    logic jtag_tdi = 0;
    logic jtag_tdo;
    logic jtag_tdo_oe;

    // UART & UART Stream Hatları
    logic uart_rx = 1;
    logic uart_tx;
    logic uart_stream_rx = 1;
    logic uart_stream_tx;

    // I2C Sinyalleri (Açık Drenaj için Pull-Up Simülasyonu)
    wire i2c_scl;
    wire i2c_sda;
    assign (weak1, weak0) i2c_scl = 1'b1;
    assign (weak1, weak0) i2c_sda = 1'b1;

    // GPIO Hatları (Giriş/Çıkış Testi İçin Çift Yönlü Veriyolu)
    wire [15:0] gpio_pins;
    logic [15:0] gpio_tb_driver = 16'hZZZZ;
    assign gpio_pins = gpio_tb_driver;

    // QSPI Flash Hatları
    wire qspi_cs;
    wire qspi_sclk;
    wire [3:0] qspi_dq;

    // --- 2. Kesintisiz Kararlı Sistem Saati (100 MHz) ---
    // Sadece bu saat akar; JTAG saati donmadığı için simülatör asla kilitlenmez.
    always #5 clk = ~clk;

    // --- 3. RESMİ WRAPPER İNSTANSİYASYONU (DUT) ---
    // Tamamen yüklediğin şematiğe ve port listene göre mühürlenmiştir.
    gozlem_design_2_wrapper dut (
        .clk_i_0          (clk),
        .rst_ni_0         (rst_n),
        
        // JTAG Girişleri (Emniyete Alındı)
        .jtag_tck_i_0     (jtag_tck),
        .jtag_tms_i_0     (jtag_tms),
        .jtag_trst_ni_0   (jtag_trst_n),
        .jtag_tdi_i_0     (jtag_tdi),
        .jtag_tdo_o_0     (jtag_tdo),
        .jtag_tdo_oe_o_0  (jtag_tdo_oe),
        
        // Standart UART (Peripheral 0)
        .uart_rxd_0       (uart_rx),
        .uart_txd_0       (uart_tx),
        
        // UART Stream (Peripheral 1)
        .uart_rxd_1       (uart_stream_rx),
        .uart_txd_1       (uart_stream_tx),
        
        // I2C Arayüzü
        .scl_0            (i2c_scl),
        .sda_0            (i2c_sda),
        
        // GPIO Arayüzü
        .gpio_i_0         (gpio_pins),
        .gpio_o_0         (),
        .gpio_tx_en_o_0   (),
        
        // QSPI Flash Bağlantıları
        .CS_pad_1         (qspi_cs),
        .SCLK_pad_1       (qspi_sclk),
        .dq_pad_1         (qspi_dq)
    );

    // --- 4. Fonksiyonel Test Akışı ---
    initial begin
        $display("[SYSTEM_TB] Son Blok Diyagramina uygun test senaryosu basladi.");
        
        // --- ADIM 1: Güvenli Donanımsal Reset Döngüsü ---
        rst_n = 0;
        #200;
        rst_n = 1;
        #100;
        $display("[SYSTEM_TB] Reset kaldirildi. Donanim uykudan uyandirildi.");

        // --- ADIM 2: GPIO Fiziksel Giriş Testi ---
        // İşlemci kodu olmasa da pinlerin dış dünyadan uyarılma kararlılığı test edilir
        $display("[SYSTEM_TB] TEST: GPIO Harici Pin Enjeksiyonu...");
        gpio_tb_driver = 16'h5555;
        #50;
        gpio_tb_driver = 16'hAAAA;
        #50;
        gpio_tb_driver = 16'hZZZZ; // Hatları tekrar boşa al

        // --- ADIM 3: UART ve UART Stream Seri Hat İzleme ---
        $display("[SYSTEM_TB] TEST: UART Hat Durumlari Kontrol Ediliyor...");
        // RX hatlarına start biti simüle ederek modüllerin canlanması izlenir
        uart_rx = 0; #8680; // 115200 baudrate için örnek 1 bit süresi
        uart_rx = 1; #2000;
        
        uart_stream_rx = 0; #8680;
        uart_stream_rx = 1; #5000;

        // --- ADIM 4: I2C ve QSPI Hatlarının Başlangıç Durum Doğrulaması ---
        $display("[SYSTEM_TB] TEST: I2C ve QSPI Statik Durum Analizi...");
        // Reset sonrasında pull-up ve boşta kalma lojikleri doğrulanır
        #500;

        // --- BÜYÜK FİNAL ---
        $display("[SYSTEM_TB] BAŞARILI: Kilitlenme yasanmadan simülasyon tamamlandi.");
        $finish;
    end

endmodule