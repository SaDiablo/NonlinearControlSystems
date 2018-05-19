%test 1
figure(1)
t = 0.01:0.01:15.00;
plot(t, set_1.output_moved(3001:4500), 'r.')
hold on
opt = stepDataOptions('StepAmplitude', 255);
step(tf1(1),opt)

%test 2
figure(2)
t = 0.02:0.02:310;
plot(t, set_2.output_moved(1000:end), 'r.')
hold on
opt = stepDataOptions('StepAmplitude', 40);
step(tf2(1),opt)