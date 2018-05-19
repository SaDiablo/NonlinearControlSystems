function [temp_1] = val_move(input_set)
%add data to temp var
temp = input_set.output;
%find biggest value before any input is added
v = find(input_set.input(:,1), 1, 'first');
val = max(input_set.output(1:v));

%zero data under plot
temp_1 = temp - val;
for i = 1 : length(temp)
    if(temp_1(i) < 0)
        temp_1(i) = 0;
    end
end
end


