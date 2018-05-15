# Summary
- Automatic control of the motors through Matlab
- drawing simplistic model of the 3d printer and it's movement
- generating trajectory for extruder.

# Source code


```C
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

	//krańcówki
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
		//pobranie wysłanych wartości z Serial Portu 
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

	//odczytaj krańcówki
	X_MIN = digitalRead(X_MIN_PIN);
	X_MAX = digitalRead(X_MAX_PIN);
	Y_MIN = digitalRead(Y_MIN_PIN);
	Y_MAX = digitalRead(Y_MAX_PIN);
	Z_MIN = digitalRead(Z_MIN_PIN);
	Z_MAX = digitalRead(Z_MAX_PIN);
	
	//Jeżeli nie ma krańcówki i są zadane kroki - rób zbocza
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

	//druga część zboczy
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
```

Draw
```Matlab
%Robienie miejsca dla nowych starych
clear stare1 stare2 stare3
%% Dane drukarki
r = 23;

x1 = 0;
y1 = 0;
z1 = 0;
z1g = 60;

x2 = 0;
y2 = 28;
z2 = 0;
z2g = 60;

x3 = 24;
y3 = 14;
z3 = 0;
z3g = 60;

%% Struktura rysująca
figure(1)
hold on
view(18.6, 8.2); 
axis square;

%Narysowanie kolumn drukarki
kol1 = line([x1 x1],... 
            [y1 y1],...
            [z1 z1g]);
        
kol2 = line([x2 x2],...
            [y2 y2],...
            [z2 z2g]);

kol3 = line([x3 x3],... 
            [y3 y3],...
            [z3 z3g]);

%Położenie startowe
xc = 12;
yc = 14;
zc = 30;

%Obliczenie położenia wóka
wozek1 = zc + sqrt(r^2 - (x1-xc)^2-(y1-yc)^2);
wozek2 = zc + sqrt(r^2 - (x2-xc)^2-(y2-yc)^2);
wozek3 = zc + sqrt(r^2 - (x3-xc)^2-(y3-yc)^2); 

%Narysowanie ramion drukarki
ramie1 = line([x1 xc],...
              [y1 yc],...
              [wozek1 zc]);

ramie2 = line([x2 xc],...
              [y2 yc],...
              [wozek2 zc]);

ramie3 = line([x3 xc],...
              [y3 yc],...
              [wozek3 zc]);

%Prealokacja struktury
point.x = xc; point.y = yc; point.z = zc;

%Rysowanie koła o środku: xc i yc
for t = 0:0.01:20
    %Wzór do podążania przez platformy (generacja trajektorii)
    x = sin(t) + xc;
    y = cos(t) + yc;
    
    %Wyliczenie pozycji wóka
    wozek1 = zc + sqrt(r^2 - (x1-x)^2-(y1-y)^2);
    wozek2 = zc + sqrt(r^2 - (x2-x)^2-(y2-y)^2);
    wozek3 = zc + sqrt(r^2 - (x3-x)^2-(y3-y)^2);
    
    %Wyłapuje brak starych (przy pierwszej iteracji)
    try 
        %Ilość pozostałych kroków dla poszczególnych wózków
        krok1 = round(wozek1 * 100) - stare1;
        krok2 = round(wozek2 * 100) - stare2;
        krok3 = round(wozek3 * 100) - stare3;       
    catch err
    end
    
    %Zmiana położeniania rysowanych ramion 
    set(ramie1, 'XData', [x1 x],...
                'YData', [y1 y],...
                'ZData', [wozek1 zc]);
            
    set(ramie2, 'XData', [x2 x],...
                'YData', [y2 y],...
                'ZData', [wozek2 zc]);
            
    set(ramie3, 'XData', [x3 x],...
                'YData', [y3 y],...
                'ZData', [wozek3 zc]);
    
    %Zapamiętanie starych (poprzednich) wartości        
    stare1 = round(wozek1*100);
    stare2 = round(wozek2*100);
    stare3 = round(wozek3*100); 
    
    %Wpisanie danych do struktury point
    point.x = [point.x; x];
    point.y = [point.y; y];
    point.z = [point.z; zc];
    
    %Rysowanie punktów co 0.1s 
    if(mod(t*100, 10) == 0)
        plot3(point.x, point.y, point.z, '.')
    end
    
    figure(1)
end
```
Send
```Matlab
%Otwórz port

%Ilośc figur do przebycia
t = 0:0.1:6*pi;

%Wzór do podążania przez platformę (generacja trajektorii)
traj_x = round(400.*sin(t));
traj_y = round(400.*cos(t));
traj_z = round(400.*sin(t));

%Ilość pozostałych kroków dla poszczególnych wózków
kroki_x = traj_x(2:end) - traj_x(1:end-1);
kroki_y = traj_y(2:end) - traj_y(1:end-1);
kroki_z = traj_z(2:end) - traj_z(1:end-1);

for i = 2:length(kroki_x)   
    %Wypisanie kolejnych kroków
    fprintf(s, '%d %d %d\n', [kroki_x(i), kroki_y(i), kroki_z(i)]);

    %Kończy krok: wychodzi z pętli (chyba)
    while(s.BytesAvailable == 0)
    end

    %Odczytuje dane z serial portu
    while(s.BytesAvailable), fscanf(s)
    end  
end
```