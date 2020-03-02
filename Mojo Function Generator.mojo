<?xml version="1.0" encoding="UTF-8"?>
<project name="Mojo Function Generator" board="Mojo V3" language="Verilog">
  <files>
    <src>sine.v</src>
    <src top="true">mojo_top.v</src>
    <src>triangle.v</src>
    <src>square.v</src>
    <src>user_interface.v</src>
    <src>saw.v</src>
    <src>gen_driver.v</src>
    <src>debounce.v</src>
    <src>rot.v</src>
    <src>transmit_rom.v</src>
    <ucf>mojo.ucf</ucf>
    <component>bin_to_dec.luc</component>
    <component>spi_slave.luc</component>
    <component>uart_rx.luc</component>
    <component>cclk_detector.luc</component>
    <component>avr_interface.luc</component>
    <component>uart_tx.luc</component>
    <core name="clk_wiz_v3_6">
      <src>clk_wiz_v3_6.v</src>
    </core>
  </files>
</project>
