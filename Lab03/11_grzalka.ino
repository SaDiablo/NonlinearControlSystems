/*
 Name:		grzalka.ino
 Created:	12/4/2018 12:48
 Author:	Kavaren, SaDiablo

 Arduino Mega 2560
 Ramps 1.4 Compatibile
*/

// Temperature Sensors
#define TEMP_0_PIN         13   // Analog Input
#define TEMP_1_PIN         15   // Analog Input
#define TEMP_BED_PIN       14   // Analog Input
#define A0                 292.686165608748
#define A1                 -0.877649103217767
#define A2                 0.00140796160025791
#define A3                 -8.15110931061918e-07

// Heaters / Fans
#define FAN_PIN           9 //4
#define FAN1_PIN          8
#define FAN2_PIN          44
#define HEATER_0_PIN      10

// The encoder and click button
#define BTN_EN1           40
#define BTN_EN2           63
#define BTN_ENC           59


int temp;
int dt = 10;
int set_temp = 80;
float u, e, temp_c, der;
float Kp = 100;
float Ki = 0.1;
float Kd = 20;
float integ = 0;
float e_pop = 0;

void setup()
{
	Serial.begin(57600);
	pinMode(FAN_PIN, OUTPUT);
	pinMode(FAN1_PIN, OUTPUT);
	pinMode(FAN2_PIN, OUTPUT);
}

void loop()
{
	temp = analogRead(TEMP_0_PIN);
	temp_c = A0 + A1 * temp + A2 * pow(temp, 2) + A3 * pow(temp, 3);

	e = set_temp - temp_c;
	integ = integ + e * dt;
	der = (e - e_pop) / dt;
	e_pop = e;
	e = constrain(e, -10, 10);
	e = map(e, -10, 10, -255, 255); 
	u = Kp * e; //Kp
	u = u + Ki * integral; //Ki
	u = u + Kd * derivative; //Kd
	u = floor(u);
	
	if(u <= 255 && u >= 0) { analogWrite(HEATER_0, u); }
	else if(u > 255) { analogWrite(HEATER_0, 255); }
	else if(u < 0) { analogWrite(HEATER_0, 0); }

	
	Serial.print("Temp: ");	Serial.print(temp);
	Serial.print(" Temp: "); Serial.print(temp_c);
	Serial.print("*C Blad:"); Serial.print(e);
	Serial.print(" Sterowanie: "); Serial.print(u);
	Serial.println("");
  
	delay(dt);
}