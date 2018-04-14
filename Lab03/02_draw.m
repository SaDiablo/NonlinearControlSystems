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

%% Inicjalizacja drukarki
if ~exist('s', 'var') 
    s = serial('COM5');
    s.BaudRate = 57600;
    fopen(s);
end

%% Struktura rysuj�ca
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

%Po�o�enie startowe
xc = 10;
yc = 10;
zc = 10;

%Obliczenie po�o�enia w�ka
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

%Rysowanie ko�a o �rodku: xc i yc
for t = 0:0.01:6.28
    %Wz�r do pod��ania przez platform� (generacja trajektorii)
    x = sin(t) + xc;
    y = cos(t) + yc;
    
    %Wyliczenie pozycji w�zk�w 
    wozek1 = zc + sqrt(r^2 - (x1-x)^2-(y1-y)^2);
    wozek2 = zc + sqrt(r^2 - (x2-x)^2-(y2-y)^2);
    wozek3 = zc + sqrt(r^2 - (x3-x)^2-(y3-y)^2);
    
    %Wy�apuje brak starych (przy pierwszej iteracji)
    try 
        %Ilo�� pozosta�ych krok�w dla poszczeg�lnych w�zk�w
        krok1 = round(200 * (wozek1 - stare1);
        krok2 = round(200 * (wozek2 - stare2);
        krok3 = round(200 * (wozek3 - stare3);
        
        %Wypisanie kolejnych krok�w
        fprintf(s, '%d %d %d\n', [krok1, krok2, krok3]);

        %Czekaj na potwierdzenie sko�czenia krok�w
        while(s.BytesAvailable == 0)
        end

        %Odczytuje dane z serial portu
        while(s.BytesAvailable), fscanf(s)
        end  
    catch err
    end
    
    %Zmiana po�o�enia rysowanych ramion 
    set(ramie1, 'XData', [x1 x],...
                'YData', [y1 y],...
                'ZData', [wozek1 zc]);
            
    set(ramie2, 'XData', [x2 x],...
                'YData', [y2 y],...
                'ZData', [wozek2 zc]);
            
    set(ramie3, 'XData', [x3 x],...
                'YData', [y3 y],...
                'ZData', [wozek3 zc]);
    
    %Zapami�tanie starych (poprzednich) warto�ci        
    stare1 = round(wozek1);
    stare2 = round(wozek2);
    stare3 = round(wozek3); 
    
    %Wpisanie danych do struktury point
    point.x = [point.x; x];
    point.y = [point.y; y];
    point.z = [point.z; zc];
    
    %Rysowanie punkt�w co 0.1s 
    if(mod(t * 100, 10) == 0)
        plot3(point.x, point.y, point.z, '.')
    end
    
    %Od�wie�enie figury
    figure(1)
end