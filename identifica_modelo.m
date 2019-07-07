%--------------------------idetifica modelo -------------------------------

%{
�	Despreze os N primeiros pontos medidos (N deve ser argumento de entrada)
�	Diferencie o dado de sa�da. (Duplique o �ltimo ponto para manter o n�mero de pontos)
�	Fa�a a identifica��o ARX com menor AIC
�	Construa a fun��o de transfer�ncia discreta e cont�nua para a identifica��o da velocidade.
�	Integre a fun��o de transfer�ncia cont�nua da velocidade obtendo um modelo cont�nuo para a posi��o. 
%}


function identifica_modelo = identifica_modelo(N)

%csv.read('SinalRbs_Bom.txt')

DATA = iddata(y,u,T);

figure(1)
plot(time,y,'r',time,u,'b')
title('grafico da entrada e saida')
legend('y - Sa�da','u - Entrada')
xlabel('time') % x-axis label
ylabel('Amplitude') % y-axis label

%--------------------------------------------------------------------------

%Escolhendo a ordem do modelo

na = 1; %ordem poli entrada
nb = 1; %ordem poli saida
nk = 1; %come�a explicar a partir de que instante passado
modeloIdentificado = arx(DATA,[na,nb,nk]); %identifica��o A(z) e B(z)

fprintf('FPE:')
FPE = modeloIdentificado.report.fit.FPE;
fprintf('AIC:')
AIC = modeloIdentificado.report.fit.AIC;

%--------------------------------------------------------------------------

%Analise dos Ru�dos

ErroClasse = resid(DATA,modeloIdentificado);
residuos = ErroClasse.y;
figure(2)
histogram(residuos,1000)
title('Histograma dos residuos') %Espera-se uma distribui��o normal

%--------------------------------------------------------------------------

%Teste de Correla��o
 
e = residuos;
lag = 10; %n�meoro de lags quistos

for i=1 : lag
    %criando matriz lag
    erro_lag(:,i) = e(lag+1-i:end-i,1)
end

e = e(lag+1:end); %pegando a matriz de entrada original e retirando os elementos do lag quisto

figure(3)
correlacao_residuos = corr(erro_lag,e)
bar(correlacao_residuos)
title('Correla��o das Saida com saidas anteriores')
xlabel('numero de lags')
ylabel('corela��o')

%------------------------------------------------------------------------

%Teste analise em frequencia
data_2 = fft(DATA);
resid(data_2,modeloIdentificado,'rx') 
grid on

%------------------------------------------------------------------------

%Criando a fun��o transferencia e Simulando

fprintf('Fun��o de transferencia discretizada:')
Gd = tf(modeloIdentificado)
fprintf('Fun��o de transferencia continua:')
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