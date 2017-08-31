
clc
clear all

N = 100000 ; //numero TOTAL de bits
sinal = randi([0 1],1,N); //gera um vetor de bits aleatórios entre 0 e 1


//TRANSFORMAÇÃO DO SINAL: 0 = -1 / 1 = 1 ;
for ii = 1:N
     if sinal(ii) == 0 
        SK(ii) = -1;
     else 
        SK(ii) = 1;
     end
end

//INICIALIZAÇÃO DOS VETORES
snr_dB = 0:1:10;
snr = zeros(0,[length(snr_dB)]);
BER = zeros(0,[length(snr_dB)]);
RK = zeros(0,[length(SK)]);

Eb = 1; //energia do bit
erro = 0;
n = 1/sqrt(2)*(randn(1,N)); //vetor aleatório utilizado na adição de ruido


for i = 1:1:length(snr_dB) 
    for ii = 1:1:N
        //SINAL DE SAIDA ADICIONADO DE UM RUIDO
        RK(ii) = SK(ii) + 10^(-snr_dB(i)/20)*n(ii);
        
        //COMPARAÇÃO
        if RK(ii) > 0
             SsK(ii) = 1;
        else
             SsK(ii) = 0;
        end        
        //CONTAGEM DE BITS ERRADOS
        if SsK(ii) ~= sinal(ii) 
             erro = erro + 1;
        end        
        
    end
    
    BER(i) = erro/N;
    erro = 0;
    
end

snr = 10.^( snr_dB/10 );
//VALOR TEORICO BER DO BPSK
vteorico = 0.5*erfc(sqrt(snr));

//PLOTAGEM
subplot(2,2,1);
plot(sinal);
axis([0 500 -2 2]);
title('SINAL DE ENTRADA');
grid on;

subplot(2,2,2);
plot(RK);
axis([0 500 -2 2]);
title('SINAL COM RUIDO');
grid on;

subplot(2,2,3);
plot(SsK);
axis([0 500 -2 2]);
title('SINAL REFITICADO / SAIDA');
grid on;

subplot(2,2,4);
semilogy(snr_dB,BER,'b.-',snr_dB,vteorico,'mx-');
title('BER');
grid on; 

scatterplot(RK);
