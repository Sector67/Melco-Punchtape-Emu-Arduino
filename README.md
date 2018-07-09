Melco-Punchtape-Emu-Arduino
===========================

Uses arduino+SD shield to emulate punch tape reader on melco embroidery machine. 
Pushes data from the first `*.dst` file it can find on a SD card.

### Pinout

SD card pins:

* CS: 10
* MOSI: 11
* MISO: 12
* SCK: 13

### pins (For Arduino Uno)  on PORTA on melco machine:

* 1-D0
* 2-D1
* 3-D2
* 4-D3
* 5-D4
* 6-D5
* 7-D6
* 8-D7
* 9-STROBE
* 10-GND
* 16-READY
