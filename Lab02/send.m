%Niedoñczony kod - nie u¿ywaæ!!!
%Otwórz port

%Iloœc figur do przebycia
t = 0:0.1:6*pi;

%Wzór do pod¹¿ania przez platformê (generacja trajektorii)
traj_x = round(400.*sin(t));
traj_y = round(400.*cos(t));
traj_z = round(400.*sin(t));

%Iloœæ pozosta³ych kroków dla poszczególnych wózków
kroki_x = traj_x(2:end) - traj_x(1:end-1);
kroki_y = traj_y(2:end) - traj_y(1:end-1);
kroki_z = traj_z(2:end) - traj_z(1:end-1);

for i = 2:length(kroki_x)   
    %Wypisanie kolejnych kroków
    fprintf(s, '%d %d %d\n', [kroki_x(i), kroki_y(i), kroki_z(i)]);

    %Koñczy krok: wychodzi z pêtli (chyba)
    while(s.BytesAvailable == 0)
    end

    %Odczytuje dane z serial portu
    while(s.BytesAvailable), fscanf(s)
    end  
end