# Summary

- Manual control of the motors corresponding to the x, y and z axes
- implementing limit switches
- reading data from serial port.

# Source code

```C
//
// Limit Switches
//
#define X_MIN_PIN           3
#define X_MAX_PIN           2
#define Y_MIN_PIN          14
#define Y_MAX_PIN          15
#define Z_MIN_PIN          18
#define Z_MAX_PIN          19

//
// Steppers
//
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

//#define E0_STEP_PIN        26
//#define E0_DIR_PIN         28
//#define E0_ENABLE_PIN      24
//#define E0_CS_PIN          42

int x, y, z;

String temp;
int kroki_x = 0;
int kroki_y = 0;
int kroki_z = 0;

void setup() 
{
    Serial.begin(115200);

    //krańcówki
    pinMode(X_MAX_PIN, INPUT);
    pinMode(Y_MAX_PIN, INPUT);
    pinMode(Z_MAX_PIN, INPUT);
    digitalWrite(Y_MAX_PIN, HIGH);
    digitalWrite(X_MAX_PIN, HIGH);
    digitalWrite(Z_MAX_PIN, HIGH);

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
    while(Serial.available())
    {
        //pobranie wysłanych wartości z Serial Portu 
        temp = Serial.readStringUntil('\n');
        //odczytanie wartości kroków do zrobienia
        sscanf(temp.c_str(), "%d %d %d\n", &kroki_x, &kroki_y, &kroki_z); 
    }

    //odczytaj krańcówki
    x = digitalRead(X_MAX_PIN);
    y = digitalRead(Y_MAX_PIN);
    z = digitalRead(Z_MAX_PIN);

    //Jeżeli nie ma krańcówki i są zadane kroki - rób zbocza
    if (x == 0 & kroki_x > 0)
    {
        digitalWrite(X_STEP_PIN, HIGH);
        kroki_x--;
    }
    if (y == 0 & kroki_y > 0)
    {
        digitalWrite(Y_STEP_PIN, HIGH);
        kroki_y--;
    }
    if (z == 0 & kroki_z > 0)
    {
        digitalWrite(Z_STEP_PIN, HIGH);
        kroki_z--;
    }

    //druga część zboczy
    delayMicroseconds(500);
    digitalWrite(X_STEP_PIN, LOW);
    digitalWrite(Y_STEP_PIN, LOW);
    digitalWrite(Z_STEP_PIN, LOW);
    delayMicroseconds(500);
}
```