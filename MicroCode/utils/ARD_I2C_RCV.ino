#include <Wire.h>

void setup()
{
  Wire.setClock(400000);
  Wire.begin(0x30);                // join i2c bus with address
  Wire.onReceive(receiveEvent); // register event
  Serial.begin(9600);           // start serial for output
};

void loop()
{
  delay(100);  
};

// function that executes whenever data is received from master
// this function is registered as an event, see setup()
void receiveEvent(void)
{
  while(1 < Wire.available()) // loop through all but the last
  {
//    char c = Wire.read(); // receive byte as a character
//    Serial.print(c);         // print the character
      uint16_t data = Wire.read() | (Wire.read() << 8);
      Serial.println(data);         // print the integer
  }
}
