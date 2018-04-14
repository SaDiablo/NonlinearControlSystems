/*
 Name:		Lab02.ino
 Created:	29/3/2018 12:48
 Author:	Kavaren, SaDiablo

 Arduino Mega 2560
 Ramps 1.4 Compatibile
*/

// Limit Switches
#define X_MIN_PIN           3
#define X_MAX_PIN			2
#define Y_MIN_PIN          14
#define Y_MAX_PIN          15
#define Z_MIN_PIN          18
#define Z_MAX_PIN          19

// Steppers
#define X_STEP_PIN         54
#define X_DIR_PIN          55
#define X_ENABLE_PIN       38
#define X_CS_PIN           53

#define Y_STEP_PIN         60
#define Y_DIR_PIN          61
#define Y_ENABLE_PIN       56
#define Y_CS_PIN           49

#define Z_STEP_PIN         46
#define Z_DIR_PIN          48
#define Z_ENABLE_PIN       62
#define Z_CS_PIN           40

int x, y, z, X_MIN, X_MAX, Y_MIN, Y_MAX, Z_MIN, Z_MAX;
int kroki_x = 0;
int kroki_y = 0;
int kroki_z = 0;
uint8_t flaga = 1; 
String temp;

void setup() 
{
	Serial.begin(9600);

	//krañcówki
	pinMode(X_MIN_PIN, INPUT_PULLUP);
	pinMode(X_MAX_PIN, INPUT_PULLUP);
	pinMode(Y_MAX_PIN, INPUT_PULLUP);
	pinMode(Y_MIN_PIN, INPUT_PULLUP);
	pinMode(Z_MAX_PIN, INPUT_PULLUP);
	pinMode(Z_MIN_PIN, INPUT_PULLUP);

	//silnik x
	pinMode(X_ENABLE_PIN, OUTPUT);
	pinMode(X_DIR_PIN, OUTPUT);
	pinMode(X_STEP_PIN, OUTPUT);
	digitalWrite(X_ENABLE_PIN, LOW);
	digitalWrite(X_DIR_PIN, LOW);

	//silnik y
	pinMode(Y_ENABLE_PIN, OUTPUT);
	pinMode(Y_DIR_PIN, OUTPUT);
	pinMode(Y_STEP_PIN, OUTPUT);
	digitalWrite(Y_ENABLE_PIN, LOW);
	digitalWrite(Y_DIR_PIN, LOW);

	//silnik z
	pinMode(Z_ENABLE_PIN, OUTPUT);
	pinMode(Z_DIR_PIN, OUTPUT);
	pinMode(Z_STEP_PIN, OUTPUT);
	digitalWrite(Z_ENABLE_PIN, LOW);
	digitalWrite(Z_DIR_PIN, LOW);
}


void loop() 
{
	//odczytaj serial port
	while(Serial.available() > 0)
	{
		//pobranie wys³anych wartoœci z Serial Portu 
		temp = Serial.readStringUntil('\n');
		//odczytanie wartoœci kroków do zrobienia
		sscanf(temp.c_str(), "%d %d %d\n", &kroki_x, &kroki_y, &kroki_z);

		flaga = 0;
		
		//ustawienie kierunku ruchu silników 
		//ze wzgledu na znak odebranych danych
		if (kroki_x < 0)
		{
			kroki_x = (-1)*kroki_x;
			digitalWrite(X_DIR_PIN, HIGH);
		}
		else { digitalWrite(X_DIR_PIN, LOW); }
		
		if (kroki_y < 0)
		{
			kroki_y = (-1)*kroki_y;
			digitalWrite(Y_DIR_PIN, HIGH);
		}
		else { digitalWrite(Y_DIR_PIN, LOW); }
		
		if (kroki_z < 0)
		{
			kroki_z = (-1)*kroki_z;
			digitalWrite(Z_DIR_PIN, HIGH);
		}
		else { digitalWrite(Z_DIR_PIN, LOW); }
	}

	//odczytaj krañcówki
	X_MIN = digitalRead(X_MIN_PIN);
	X_MAX = digitalRead(X_MAX_PIN);
	Y_MIN = digitalRead(Y_MIN_PIN);
	Y_MAX = digitalRead(Y_MAX_PIN);
	Z_MIN = digitalRead(Z_MIN_PIN);
	Z_MAX = digitalRead(Z_MAX_PIN);
	
	//Je¿eli nie ma krañcówki i s¹ zadane kroki - rób zbocza
	if (!X_MAX & kroki_x > 0)
	{
		digitalWrite(X_STEP_PIN, LOW);
		kroki_x--;
	}
	if (!Y_MAX & kroki_y > 0)
	{
		digitalWrite(Y_STEP_PIN, LOW);
		kroki_y--;
	}
	if (!Z_MAX & kroki_z > 0)
	{
		digitalWrite(Z_STEP_PIN, LOW);
		kroki_z--;
	}

	//druga czêœæ zboczy
	delayMicroseconds(500);
	digitalWrite(X_STEP_PIN, HIGH);
	digitalWrite(Y_STEP_PIN, HIGH);
	digitalWrite(Z_STEP_PIN, HIGH);
	delayMicroseconds(500);
	
	//zakoñczenie wykonywania odebranej akcji
	if (kroki_x == 0 && kroki_y == 0 && kroki_z == 0 && flaga == 0)
	{
		Serial.println("ACK");
		flaga = 1;
	}
}
