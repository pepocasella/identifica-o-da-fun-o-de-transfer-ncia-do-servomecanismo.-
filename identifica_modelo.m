%--------------------------idetifica modelo -------------------------------

%{
•	Despreze os N primeiros pontos medidos (N deve ser argumento de entrada)
•	Diferencie o dado de saída. (Duplique o último ponto para manter o número de pontos)
•	Faça a identificação ARX com menor AIC
•	Construa a função de transferência discreta e contínua para a identificação da velocidade.
•	Integre a função de transferência contínua da velocidade obtendo um modelo contínuo para a posição. 
%}


function identifica_modelo = identifica_modelo(N)

%csv.read('SinalRbs_Bom.txt')

DATA = iddata(y,u,T);

figure(1)
plot(time,y,'r',time,u,'b')
title('grafico da entrada e saida')
legend('y - Saída','u - Entrada')
xlabel('time') % x-axis label
ylabel('Amplitude') % y-axis label

%--------------------------------------------------------------------------

%Escolhendo a ordem do modelo

na = 1; %ordem poli entrada
nb = 1; %ordem poli saida
nk = 1; %começa explicar a partir de que instante passado
modeloIdentificado = arx(DATA,[na,nb,nk]); %identificação A(z) e B(z)

fprintf('FPE:')
FPE = modeloIdentificado.report.fit.FPE;
fprintf('AIC:')
AIC = modeloIdentificado.report.fit.AIC;

%--------------------------------------------------------------------------

%Analise dos Ruídos

ErroClasse = resid(DATA,modeloIdentificado);
residuos = ErroClasse.y;
figure(2)
histogram(residuos,1000)
title('Histograma dos residuos') %Espera-se uma distribuição normal

%--------------------------------------------------------------------------

%Teste de Correlação
 
e = residuos;
lag = 10; %númeoro de lags quistos

for i=1 : lag
    %criando matriz lag
    erro_lag(:,i) = e(lag+1-i:end-i,1)
end

e = e(lag+1:end); %pegando a matriz de entrada original e retirando os elementos do lag quisto

figure(3)
correlacao_residuos = corr(erro_lag,e)
bar(correlacao_residuos)
title('Correlação das Saida com saidas anteriores')
xlabel('numero de lags')
ylabel('corelação')

%------------------------------------------------------------------------

%Teste analise em frequencia
data_2 = fft(DATA);
resid(data_2,modeloIdentificado,'rx') 
grid on

%------------------------------------------------------------------------

%Criando a função transferencia e Simulando

fprintf('Função de transferencia discretizada:')
Gd = tf(modeloIdentificado)
fprintf('Função de transferencia continua:')
G = d2c(Gd)

%sinal de Step no analog
uStep = ones(10000,1);
s.queueOutputData(uStep);
[yStep,timeStep,triggerTimeStep] = s.startForeground;


figure(4)
step(Gd,'c*')
hold on
step(G,'r')
hold on
plot(timeStep,uStep,'b');
plot(timeStep,yStep,'g');
legend('Gd','G')
grid on






end