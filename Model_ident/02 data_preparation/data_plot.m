%% prepare data
     
set.dt = dt;
set.temp_data = str2num(char(data_str));
set.i = set.temp_data(:, 1);
set.input(:, 1) = set.temp_data(:, 2);
set.input(:, 2) = ones(size(set.temp_data, 1),1) * 255;
set.output_notconv = set.temp_data(:, 3);

%% Przeliczenie na *C
set.p = [-2.85862865193471e-22 1.37915877531792e-18 -2.82921036032545e-15 3.21618652720870e-12 -2.21475224694936e-09 9.49919288351029e-07 -0.000252217024037494 0.0402867301683181 -3.84921945549064 350.037053704701];
set.output = set.p(1)*set.output_notconv.^9 + set.p(2)*set.output_notconv.^8 + set.p(3)*set.output_notconv.^7 +...
              set.p(4)*set.output_notconv.^6 + set.p(5)*set.output_notconv.^5 + set.p(6)*set.output_notconv.^4 +...
              set.p(7)*set.output_notconv.^3 + set.p(8)*set.output_notconv.^2 + set.p(9)*set.output_notconv + set.p(10);

%% filtr i identyfikacja
set.output_moved = val_move(set);
set.output_filtered(1, 1) = set.output(2);
set.output_filtered_moved(1, 1) = set.output_moved(2);

for i = 2 : 1 : size(set.output, 1)
    set.output_filtered(i, 1) = (set.output_filtered(i-1) * 20 + set.output(i)) / 21;
end

for i = 2 : 1 : size(set.output, 1)
    set.output_filtered_moved(i, 1) = (set.output_filtered_moved(i-1) * 20 + set.output_moved(i)) / 21;
end

set.object = iddata(set.output, set.input, (dt/1000), 'InputUnit', {'PWM value (0-255)', 'PWM value (0-255)'}, 'OutputUnit', 'Celsius');
set.object_filtered = iddata(set.output_filtered, set.input, (dt/1000), 'InputUnit', {'PWM value (0-255)', 'PWM value (0-255)'}, 'OutputUnit', 'Celsius');
set.object_moved = iddata(set.output_moved, set.input, (dt/1000), 'InputUnit', {'PWM value (0-255)', 'PWM value (0-255)'}, 'OutputUnit', 'Celsius');
set.object_filtered_moved = iddata(set.output_filtered_moved, set.input, (dt/1000), 'InputUnit', {'PWM value (0-255)', 'PWM value (0-255)'}, 'OutputUnit', 'Celsius');

%% turn set into data.set
data.set = set;
%data.set_1 = set_1;
%data.set_2 = set_2;

%% plot
close all

% figure(1) 
% hold on
% plot(data.set_1.i*(data.set_1.dt/1000), data.set_1.output, '.');
% plot(data.set_1.i*(data.set_1.dt/1000), data.set_1.output_filtered, '.');
%  
% plot(data.set_2.i*(data.set_2.dt/1000), data.set_2.output, '.');
% plot(data.set_2.i*(data.set_2.dt/1000), data.set_2.output_filtered, '.');

names = fieldnames(data);
figure(1)
hold on
for ind = 1 : length(names)
  plot(data.(names{ind}).i*(data.(names{ind}).dt/1000), data.(names{ind}).output, '.');
  plot(data.(names{ind}).i*(data.(names{ind}).dt/1000), data.(names{ind}).output_filtered, '.');
  plot(data.(names{ind}).i*(data.(names{ind}).dt/1000), data.(names{ind}).output_moved, '.');
  plot(data.(names{ind}).i*(data.(names{ind}).dt/1000), data.(names{ind}).output_filtered_moved, '.');
end

clear ind