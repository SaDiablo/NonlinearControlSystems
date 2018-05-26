%% Instrument Connection

% Find a serial port object.
obj1 = instrfind('Type', 'serial', 'Port', 'COM11', 'Tag', '');

% Create the serial port object if it does not exist
% otherwise use the object that was found.
if isempty(obj1)
    obj1 = serial('COM11');
else
    fclose(obj1);
    obj1 = obj1(1);
end

% Connect to instrument object, obj1.
fopen(obj1);

%% Instrument Configuration and Control

% Configure instrument object, obj1.
set(obj1, 'BaudRate', 57600);

% Communicating with instrument object, obj1.
seconds = 360;
dt = 20; %ms
samples = seconds * (1000/dt);

data_str = string(zeros(samples, 1));
time = zeros(samples, 1);
i = 1;

while(i <= samples)
   tic
   data_str(i) = fscanf(obj1);
   time(i) = toc;
   i = i + 1;
end

%% Disconnect and Clean Up

% Disconnect from instrument object, obj1.
fclose(obj1);