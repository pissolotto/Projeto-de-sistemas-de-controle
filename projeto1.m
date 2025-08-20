% -------------------------------------------------------------------------
% UFABC - SISTEMAS DE CONTROLE I
% TRABALHO - EXERCÍCIO 1
% Alunos: Luan Gibin Fernandes Pereira, Renan Ribeiro Pissolotto
% -------------------------------------------------------------------------

clear
clc
close all

% ==========================================================
% REQUISITOS DE PROJETO
% ==========================================================
% Sobressinal Máximo (Mp) = 16%
% Tempo de Acomodação (ts, 2%) = 2s
% Planta G(s) = 4 / (s*(s+2))

% ==========================================================
% ANÁLISE DO SISTEMA ORIGINAL (SEM COMPENSADOR)
% ==========================================================
disp('======================================================');
disp('1. ANÁLISE DO SISTEMA NÃO COMPENSADO');
disp('======================================================');

% --- Funções de Transferência ---
numerador_G = [4];
denominador_G = [1 2 0];
Gs = tf(numerador_G, denominador_G);

disp('Função de Transferência em Malha Aberta (G(s)):');
Gs

Gmf = feedback(Gs, 1);
disp('Função de Transferência em Malha Fechada (Gmf(s)):');
Gmf

% --- Polos e Zeros ---
disp('Polos e Zeros da Malha Fechada (sem compensador):');
[polos_Gmf, zeros_Gmf] = pzmap(Gmf);
fprintf('Polos: \n');
disp(polos_Gmf);
if isempty(zeros_Gmf)
    disp('Zeros: Nenhum');
else
    fprintf('Zeros: \n');
    disp(zeros_Gmf);
end
disp('------------------------------------------------------');
fprintf('\n\n');

% ==========================================================
% PROJETO E ANÁLISE DO SISTEMA COMPENSADO
% ==========================================================
disp('======================================================');
disp('2. PROJETO E ANÁLISE DO SISTEMA COMPENSADO');
disp('======================================================');

% --- Projeto do Compensador Gc(s) ---
% Baseado nos cálculos do relatório: Gc(s) = Kc * (s+zc)/(s+zp)
% Com cancelamento do polo em s=-2, temos o zero do compensador zc = 2.
% Para um ângulo de 46 graus, calculou-se o polo do compensador zp = 5.59.
% O ganho Kc foi ajustado para ~4 para que o módulo seja 1.

ganho_c = 4;
zero_c = 2;
polo_c = 5.59;
numerador_Gc = ganho_c * [1 zero_c];
denominador_Gc = [1 polo_c];
Gcs = tf(numerador_Gc, denominador_Gc);

disp('Função de Transferência do Compensador Projetado (Gc(s)):');
Gcs

% --- Funções de Transferência do Sistema Compensado ---
G_compensado_s = series(Gcs, Gs);
disp('Função de Transferência em Malha Aberta Compensada (Gc(s)G(s)):');
G_compensado_s

G_compensado_mf = feedback(G_compensado_s, 1);
disp('Função de Transferência em Malha Fechada Compensada:');
G_compensado_mf

% --- Polos e Zeros ---
disp('Polos e Zeros da Malha Fechada (com compensador):');
[polos_G_compensado_mf, zeros_G_compensado_mf] = pzmap(G_compensado_mf);
fprintf('Polos: \n');
disp(polos_G_compensado_mf);
if isempty(zeros_G_compensado_mf)
    disp('Zeros: Nenhum');
else
    fprintf('Zeros: \n');
    disp(zeros_G_compensado_mf);
end
disp('------------------------------------------------------');

% ==========================================================
% GERAÇÃO DOS GRÁFICOS COMPARATIVOS
% ==========================================================

% --- Gráfico 1: Lugar das Raízes (LGR) ---
figure('Name', 'Lugar das Raízes (Comparativo)')
hold on
rlocus(Gs, 'r--')
rlocus(G_compensado_s, 'g-')
title('Lugar das Raízes: Original vs. Compensado')
legend('Sistema Original', 'Sistema Compensado')
grid on
hold off

% --- Gráfico 2: Resposta ao Degrau Unitário ---
figure('Name', 'Resposta ao Degrau Unitário (Comparativo)')
hold on
step(Gmf, 'r--')
step(G_compensado_mf, 'g-')
title('Comparação da Resposta ao Degrau Unitário')
legend('Sistema Original', 'Sistema Compensado')
grid on
hold off

% --- Gráfico 3: Resposta à Rampa Unitária ---
figure('Name', 'Resposta à Rampa Unitária (Comparativo)')
t = 0:0.01:10; % Define um vetor de tempo
rampa = t;     % Rampa unitária u(t) = t

% Calcula a resposta de cada sistema à entrada de rampa
saida_original = lsim(Gmf, rampa, t);
saida_compensada = lsim(G_compensado_mf, rampa, t);

% Plota as respostas calculadas e a referência
hold on
plot(t, saida_original, 'r--')
plot(t, saida_compensada, 'g-')
plot(t, rampa, 'k:')
title('Comparação da Resposta à Rampa Unitária')
legend('Sistema Original', 'Sistema Compensado', 'Referência')
grid on
hold off
