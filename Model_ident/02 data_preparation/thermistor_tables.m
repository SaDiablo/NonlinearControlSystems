%% Thermistor Tables
%todo, some kind of choosing thermistor by number
function [p] = thermistor_tables(x)

%5 - 4.7k thermistor
table5.x = [17; 20; 23; 27; 31; 37; 43; 51; 61; 73; 87; 106; 128; 155; 189; 230; 278; 336; 402; 476; 554; 635; 713; 784; 846; 897; 937; 966; 986; 1000; 1010];
table5.y = [300; 290; 280; 270; 260; 250; 240; 230; 220; 210; 200; 190; 180; 170; 160; 150; 140; 130; 120; 110; 100; 90; 80; 70; 60; 50; 40; 30; 20; 10; 0];

% Preparing data to fit
[xData, yData] = prepareCurveData(table5.x, table5.y);

% Set up fittype and options.
ft = fittype('poly9');
opts = fitoptions('Method', 'LinearLeastSquares');
opts.Robust = 'LAR';

% Fit model to data.
[f, gof] = fit(xData, yData, ft, opts);

p = [f.p1 f.p2 f.p3 f.p4 f.p5 f.p6 f.p7 f.p8 f.p9 f.p10];

end