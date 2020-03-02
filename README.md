# Mojo-Function-Generator
This Verilog code is made for the Mojo V3 FPGA development board by Embedded Micro: https://embeddedmicro.com/

Purpose:
  Creates different waveforms on the FPGA that can then be output to a parrallel ADC.

Specs:
  Clock:
    The Mojo features a 50MHz clock. This clock is split and multiplied in the FPGA to 50MHz and 200MHz clocks. The 50MHz clock is used for calculation, serial communication and generic purposes. The 200MHz clock is solely reserved for waveform sythesis.

  Maximum output frequency:
   Triangle: 800KHz
   Sine, Saw: 3MHz
   Square: >10MHz

  Maximum output voltage:
    FPGA: 3V3
    Function Gen Board: +/-8V

Hardware:
  My hardware consists of the FPGA board and a proto board. 
  On the protoboard the outputs of the FPGA are connected to an R-2R resistance ladder where R=1K
  The output voltage of the resistance ladder is then connected to the non-inverting input of an LT1363 opamp which is connected to +/- 12V
  The inverting input is connected to a 10K(20K may be better) potentiometer. One terminal of this pot is connected to the opamp output while the other is connected to another 10K pot. This pot controls the opamp gain.
  The second 10K pot is connected to 5V via the Mojo "raw" pin and ground. This pot controls the DC offset.
  This setup exhibits ringing at freq >500KHz.

**CORE GEN NOTE** Since I don't have permission to post the CoreGen code created by Xilinx tools, its code has been ommitted. To run the device at 50MHz vice 200MHz clock simply replace the <code>cgclk</code> signal
