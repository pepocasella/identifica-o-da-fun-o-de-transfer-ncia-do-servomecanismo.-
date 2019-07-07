
%-------------------------sinal de entrada RBS-----------------------------

%{
•	Duração do sinal em segundos.
•	Sample time em segundos.
•	Off set do sinal 
•	Amplitude do sinal
•	A frequência mínima do sinal 
•	A frequência máxima do sinal.
%}
 
fMin = 1/100; %5Hz
fMax = 1/20; %25Hz           freq_real_max/Sample_Time
min = -0.48;
max = 0.52;

duracao = 15;
Ts = 0.002;

numPontos = duracao/Ts;
u = idinput(numPontos,'rbs',[fMin fMax],[min,max]);
t = linspace(0,duracao, numPontos);

plot(t,u)
title('Sinal RBS')
xlabel('time') % x-axis label
ylabel('Amplitude') % y-axis label

csvwrite('sinalRBS2.csv',u) % 

%--------------------------------------------------------------------------

