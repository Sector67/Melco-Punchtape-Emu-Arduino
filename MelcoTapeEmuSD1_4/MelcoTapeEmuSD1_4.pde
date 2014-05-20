/*  By Joe Kerman jkerman@gmail.com  All copyrights given to Sector67.org
reads a paper tape formatted binary file (.DST for example) from an SD card
and send the bytes to the Melco SuperStar embroidery machine at Sector67 in a paralell printer port format
This takes the first .dst file it finds on the card, there should be only one file on the card to preserve sanity

PORTA on melco machine
1-D0
2-D1
3-D2
4-D3
5-D4
6-D5
7-D6
8-D7
9-STROBE
10-GND
16-READY




CHANGELOG

1.0 - Initial release 
-is READY active high or active low because it goes through the schmidtt inverter? 

1.3 - Talks to melco correctly now. fixed huge flaw in bit output pins

1.4 - Fixed bug preventing files larger than 32k from working

*/

#include <SD.h>

const int DataPins[] = {2,3,4,5,6,7,8,9}; // D0-D7 of parallel port output to Melco
const int SDChipSelect = 10;              // SD card uses pins 10(CS), 11(MOSI), 12(MISO), 13(SCK)
const int StrobePin = A0;                 // Strobe output to Melco
const int ReadyPin = A1;                  // Ready to read signal from Melco

const int StrobeWait = 2;                 // microseconds to hold strobe line high 
const int delayperbyte = 20;              // force delay when transmitting bytes, for sanity 

boolean headersent = false;
byte inByte ;                       
int Ack;
char* entryName;
void setup()
{
  int bytessent = 0;
  pinMode(DataPins[0], OUTPUT);
  pinMode(DataPins[1], OUTPUT);
  pinMode(DataPins[2], OUTPUT);
  pinMode(DataPins[3], OUTPUT);
  pinMode(DataPins[4], OUTPUT);
  pinMode(DataPins[5], OUTPUT);
  pinMode(DataPins[6], OUTPUT);
  pinMode(DataPins[7], OUTPUT);
  pinMode(StrobePin, OUTPUT);  // is active LOW
  pinMode(ReadyPin, INPUT);    // is active HIGH 
  pinMode(SDChipSelect, OUTPUT);
 
   while (!SD.begin(SDChipSelect)) {  // keep trying the card until we see it 
      }
  
  // Search the SD card for the first .DST file we can find
  File root = SD.open("/");
  int length;  
  boolean FoundDST = false;
  while (FoundDST == false) {
  File entry = root.openNextFile();
  entryName = entry.name();
  length = strlen(entry.name());
   if (strstr(strlwr(entry.name() + (length - 4)), ".dst")) {
    FoundDST = true;
   }
  }
  

  
  File datafile = SD.open(entryName);
   while (datafile.available()) {
      inByte = datafile.read();  //get a byte from the file
      if ((bytessent<512) && (headersent == false)) {       // strip the first 512 bytes of the header
       inByte = 0;
      }
      
      if ((headersent == false) && (bytessent==512) ) {
        headersent = true;
      }
      
      int b0 = bitRead(inByte, 0);         // split the byte into bits
      int b1 = bitRead(inByte, 1);
      int b2 = bitRead(inByte, 2);
      int b3 = bitRead(inByte, 3);
      int b4 = bitRead(inByte, 4);
      int b5 = bitRead(inByte, 5);
      int b6 = bitRead(inByte, 6);
      int b7 = bitRead(inByte, 7);
    
      digitalWrite(DataPins[0], b0);        // set data bit pins
      digitalWrite(DataPins[1], b1);
      digitalWrite(DataPins[2], b2);
      digitalWrite(DataPins[3], b3);
      digitalWrite(DataPins[4], b4);
      digitalWrite(DataPins[5], b5);
      digitalWrite(DataPins[6], b6);
      digitalWrite(DataPins[7], b7);
    
      digitalWrite(StrobePin, LOW);       // strobe to have melco read the bits
      delayMicroseconds(StrobeWait);
      digitalWrite(StrobePin, HIGH);
      Ack=1;
      while ( Ack == 1 ) { //Listen for ready signal before sending next byte
        Ack = digitalRead(ReadyPin);
        } 
      bytessent++;
      delay(delayperbyte);  
     
   }
  


  
}


  void loop()
{
 
 
}


  
  
  
  
  
  
  
  
  
  

