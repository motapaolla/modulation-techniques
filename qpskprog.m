
clc
clear all

N = 1000 ; %taxa de bits
input = randi([0 1],1,N) + j*randi([0 1],1,N); %gera um vetor de bits aleatórios entre 0 e 1

%MODULAÇÃO DO SINAL:

SKre = zeros(1,N);
SKim = zeros(1,N);

inputim = imag(input);
inputre = real(input);

%MODULAÇÃO DA PARTE REAL
for ii = 1:N 
     if inputre(ii) == 0 
        SKre(ii) = -1;
     else 
        SKre(ii) = 1;
     end
end

%MODULAÇÃO DA PARTE IMAGINARIA
for ii = 1:N 
     if inputim(ii) == 0 
        SKim(ii) = -1;
     else 
        SKim(ii) = 1;
     end
end

s = SKre + j*SKim;
SK = (1/sqrt(2))*s;

%INICIALIZAÇÃO DOS VETORES
snr_dB = 0:1:10;
snr = zeros(0,[length(snr_dB)]);
BER = zeros(0,[length(snr_dB)]);
RK = zeros(0,[length(SK)]);
SsKre = zeros(0,N);
SsKim = zeros(0,N);
RKim = zeros(0,N);
RKre = zeros(0,N);
erro = 0;

% vetor aleatório utilizado na adição de ruido
n = 1/sqrt(2)*[randn(1,N) + j*randn(1,N)]; 

for i = 1:length(snr_dB)
    for ii = 1:1:N
        
        %SINAL DE SAIDA + RUIDO
        RK(ii) = SK(ii) + 10^(-snr_dB(i)/20)*n(ii);
        
        %DEMODULAÇÃO        
        RKim = imag(RK);
        RKre = real(RK);
                
        if RKim(ii) > 0 %parte imaginaria
             SsKim(ii) = 1;
        else
             SsKim(ii) = 0;
        end
        
        if RKre(ii) > 0 %parte real
             SsKre(ii) = 1;
        else
             SsKre(ii) = 0;
        end   
        
        SsK = SsKre + j*SsKim; %junção da parte real com a imaginaria
        
        %CONTAGEM DE BITS ERRADOS
        if SsK(ii) ~= input(ii) 
             erro = erro + 1;
        end         
    end
    BER(i) = erro/N;
    erro = 0;
    
end
    

snr = 10.^( snr_dB/10 );

%VALOR TEORICO BER DO QPSK
vteorico = erfc(sqrt(0.5*(snr)));

semilogy(snr_dB,BER,'b.-',snr_dB,vteorico,'mx-');
legend('simulation','theory');
title('BER');
grid on;        
    
scatterplot(RK);
    
    