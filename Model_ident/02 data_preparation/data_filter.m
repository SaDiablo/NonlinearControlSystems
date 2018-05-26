temp_old(1, 1) = temp_c(2);
for i = 2 : 1 : size(temp_c, 1)
    temp_old(i, 1) = (temp_old(i-1) * 20 + temp_c(i)) / 21;
end
