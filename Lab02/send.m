%Niedo�czony kod - nie u�ywa�!!!
%Otw�rz port

%Ilo�c figur do przebycia
t = 0:0.1:6*pi;

%Wz�r do pod��ania przez platform� (generacja trajektorii)
traj_x = round(400.*sin(t));
traj_y = round(400.*cos(t));
traj_z = round(400.*sin(t));

%Ilo�� pozosta�ych krok�w dla poszczeg�lnych w�zk�w
kroki_x = traj_x(2:end) - traj_x(1:end-1);
kroki_y = traj_y(2:end) - traj_y(1:end-1);
kroki_z = traj_z(2:end) - traj_z(1:end-1);

for i = 2:length(kroki_x)   
    %Wypisanie kolejnych krok�w
    fprintf(s, '%d %d %d\n', [kroki_x(i), kroki_y(i), kroki_z(i)]);

    %Ko�czy krok: wychodzi z p�tli (chyba)
    while(s.BytesAvailable == 0)
    end

    %Odczytuje dane z serial portu
    while(s.BytesAvailable), fscanf(s)
    end  
end