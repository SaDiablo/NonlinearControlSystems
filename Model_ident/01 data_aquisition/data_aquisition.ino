/*
 Name:		grzalka.ino
 Created:	12/4/2018 12:48
 Author:	Kavaren, SaDiablo

 Arduino Mega 2560
 Ramps 1.4 Compatibile
*/
#include <LiquidCrystal.h>
#include <ClickEncoder.h>
#include <TimerOne.h>

// Temperature Sensors
#define TEMP_0_PIN         13   // Analog Input (Nozzle temp)
#define TEMP_1_PIN         15   // Analog Input (Outside temp)

// Heaters / Fans
#define FAN_PIN           9 //4
#define FAN2_PIN          44
#define HEATER_0_PIN      10

// LCD pins
#define RS 		16
#define ENABLE 	17
#define D4 		23
#define D5 		25
#define D6 		27
#define D7 		29

// Encoder
#define BTN_EN1 31 // encoder
#define BTN_EN2 33 // encoder
#define BTN_ENC 35 // enter button

//Thermistor tables
#define A0 		350.037053704701
#define A1 		 -3.84921945549064
#define A2 		  0.0402867301683181
#define A3 		 -0.000252217024037494
#define A4 		  9.49919288351029e-07 
#define A5 		 -2.21475224694936e-09
#define A6 		  3.21618652720870e-12 
#define A7		 -2.82921036032545e-15
#define A8		  1.37915877531792e-18 
#define A9		 -2.85862865193471e-22 

LiquidCrystal lcd(RS, ENABLE, D4, D5, D6, D7);
ClickEncoder *encoder;
String input_var;
int t_zew, t, flag;
float t_c;
int16_t last, value;
int u = 0;
int i = 0;
int dt = 20;

void timerIsr() {
  encoder->service();
}

void setup()
{
	//Serial.begin(57600);
	lcd.begin(20, 4);
	
	pinMode(FAN_PIN, OUTPUT);
	pinMode(FAN2_PIN, OUTPUT);
	pinMode(HEATER_0_PIN, OUTPUT);
	
	digitalWrite(FAN_PIN, HIGH);
	digitalWrite(FAN2_PIN, HIGH);

  encoder = new ClickEncoder(BTN_EN2, BTN_EN1, BTN_ENC);
  encoder->setAccelerationEnabled(true);
  Timer1.initialize(1000);
  Timer1.attachInterrupt(timerIsr); 
  
  last = -1;
}

void loop()
{
  value += encoder->getValue();
  if (value != last) 
  {
    last = value;
  }
  ClickEncoder::Button b = encoder->getButton();
  if (b != ClickEncoder::Open) 
  {
    switch (b) 
    {
      case ClickEncoder::Clicked:
          u = value;  
      break;
      case ClickEncoder::DoubleClicked:
        u = 0;
        value = 0;
      break;
    }
  }
	while(Serial.available() > 0)
	{
		input_var = Serial.readStringUntil('\n');
		sscanf(input_var.c_str(), "%d\n", &u);
	}


	//if(i > 50000)
	//{ u = 40; }
	//else if (i > 180000)
	//{ u = 0; }
 
	analogWrite(HEATER_0_PIN, u);
	
	t = analogRead(TEMP_0_PIN);
	//t_c = A0 + A1 * t + A2 * pow(t, 2) + A3 * pow(t, 3) + A4 * pow(t, 4) + A5 * pow(t, 5) + A6 * pow(t, 6) + A7 * pow(t, 7) + A8 * pow(t, 8) + A9 * pow(t, 9);
	//temp_zew = analogRead(TEMP_1_PIN);
	lcd.setCursor(0, 0);
	lcd.print("krok: "); lcd.print(i);  lcd.print("    ");
	lcd.setCursor(0, 1);
	lcd.print("ster: "); lcd.print(u);  lcd.print("    ");
	lcd.setCursor(0, 2);
	lcd.print("temp: "); lcd.print(t);  lcd.print("    ");
	lcd.setCursor(0, 3);
	lcd.print("pos: "); lcd.print(value); lcd.print("    ");
	Serial.print(i); Serial.print(" ");
	Serial.print(u); Serial.print(" ");
	Serial.print(t); Serial.print(" ");
	//Serial.print(t_zew); Serial.print(" ");
	Serial.println("");

	delay(dt-15);
	delayMicroseconds(1800);
	i++;
}
