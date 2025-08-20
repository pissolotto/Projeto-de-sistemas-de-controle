% -------------------------------------------------------------------------
% UFABC - SISTEMAS DE CONTROLE I
% TRABALHO - EXERCÍCIO 3
% Alunos: Luan Gibin Fernandes Pereira, Renan Ribeiro Pissolotto
% -------------------------------------------------------------------------

clear
clc
close all

% ==========================================================
% ANÁLISE DO SISTEMA ORIGINAL (SEM COMPENSADOR)
% ==========================================================
disp('======================================================');
disp('1. ANÁLISE DO SISTEMA NÃO COMPENSADO (EX. 3)');
disp('======================================================');

% --- Funções de Transferência ---
numerador_G = [10];
denominador_G = [1 10 16 0]; % s^3 + 10s^2 + 16s
Gs = tf(numerador_G, denominador_G);
Gmf = feedback(Gs, 1);

disp('Função de Transferência em Malha Aberta Original (G(s)):');
Gs

% ==========================================================
% PROJETO E ANÁLISE DOS SISTEMAS COMPENSADOS
% ==========================================================
disp('======================================================');
disp('2. PROJETO E ANÁLISE DOS SISTEMAS COMPENSADOS (EX. 3)');
disp('======================================================');

% --- Projeto dos Compensadores ---

% Parte 1: Compensador de Avanço (Lead)
Kc_lead = 2.77;
zc_lead = 2;
pc_lead = 8;
Gc_lead = tf(Kc_lead * [1 zc_lead], [1 pc_lead]);
disp('Compensador de Avanço (Lead) Gc_lead(s):');
Gc_lead

% Parte 2: Compensador de Atraso (Lag)
zc_lag = 0.1;
pc_lag = 0.0043;
Gc_lag = tf([1 zc_lag], [1 pc_lag]);
disp('Compensador de Atraso (Lag) Gc_lag(s):');
Gc_lag

% Parte 3: Compensador Final (Avanço-Atraso)
Gcs = series(Gc_lead, Gc_lag);
disp('Compensador Final Projetado (Gc(s)):');
Gcs

% --- Criação dos Sistemas Compensados ---

% Sistema Intermediário (Compensado apenas por Avanço)
G_lead_s = series(Gc_lead, Gs);
G_lead_mf = feedback(G_lead_s, 1);
disp('FT Malha Aberta Compensada por Avanço:');
G_lead_s

% Sistema Final (Compensado por Avanço-Atraso)
G_final_s = series(Gcs, Gs);
G_final_mf = feedback(G_final_s, 1);
disp('FT Malha Aberta Compensada Final:');
G_final_s

% ==========================================================
% GERAÇÃO DOS GRÁFICOS COMPARATIVOS
% ==========================================================

% --- Gráfico 1: Lugar das Raízes (LGR) ---
figure('Name', 'Lugar das Raízes (Comparativo Ex. 3)')
hold on
rlocus(Gs, 'b-')         % Original em azul
rlocus(G_lead_s, 'g-')   % Compensado por avanço em verde
rlocus(G_final_s, 'r--') % Compensado final em vermelho tracejado
title('Lugar das Raízes: Comparativo')
legend('Não compensado', 'Compensado por Avanço', 'Compensado Final (Avanço-Atraso)')
grid on
hold off

% --- Gráfico 2: Resposta ao Degrau Unitário ---
figure('Name', 'Resposta ao Degrau Unitário (Comparativo Ex. 3)')
hold on
step(Gmf, 'b-')
step(G_lead_mf, 'g-')
step(G_final_mf, 'r--')
title('Resposta ao Degrau Unitário (Malha Fechada)')
legend('Não compensado', 'Compensado por Avanço', 'Compensado Final (Avanço-Atraso)')
grid on
hold off

% --- Gráfico 3: Resposta à Rampa Unitária ---
figure('Name', 'Resposta à Rampa Unitária (Comparativo Ex. 3)')
t = 0:0.1:40; % Define um vetor de tempo
rampa = t;

% Calcula a resposta de cada sistema à entrada de rampa
saida_original = lsim(Gmf, rampa, t);
saida_lead = lsim(G_lead_mf, rampa, t);
saida_final = lsim(G_final_mf, rampa, t);

% Plota as respostas calculadas e a referência
hold on
plot(t, rampa, 'b--') % Referência
plot(t, saida_original, 'b-')
plot(t, saida_lead, 'g-')
plot(t, saida_final, 'r-') % Usando linha sólida para melhor visualização do erro
title('Resposta à Rampa Unitária (Malha Fechada)')
legend('Referência (Rampa)', 'Não compensado', 'Compensado por Avanço', 'Compensado Final (Avanço-Atraso)')
grid on
hold off
