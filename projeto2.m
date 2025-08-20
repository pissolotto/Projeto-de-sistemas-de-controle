% -------------------------------------------------------------------------
% UFABC - SISTEMAS DE CONTROLE I
% TRABALHO - EXERCÍCIO 2
% -------------------------------------------------------------------------

clear
clc
close all

% ==========================================================
% REQUISITOS DE PROJETO
% ==========================================================
% Erro Estacionário para degrau unitário (ess) = 0.02
% Planta G(s) = 40 / ((s+1)^2 * (s+10))

% ==========================================================
% ANÁLISE DO SISTEMA ORIGINAL (SEM COMPENSADOR)
% ==========================================================
disp('======================================================');
disp('1. ANÁLISE DO SISTEMA NÃO COMPENSADO');
disp('======================================================');

% --- Funções de Transferência ---
numerador_G = [40];
denominador_G = conv([1 2 1], [1 10]); % (s+1)^2 * (s+10)
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
% Baseado nos cálculos do relatório: Gc(s) = (s+zc) / (s+pc)
% O zero e o polo são colocados próximos à origem para não alterar
% significativamente a resposta transiente.
% zc = 0.1
% pc = 0.00816

zero_c = 0.1;
polo_c = 0.00816;
numerador_Gc = [1 zero_c];
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
rampa = t;      % Rampa unitária u(t) = t

% Calcula a resposta de cada sistema à entrada de rampa
[y_original, t_original] = lsim(Gmf, rampa, t);
[y_compensada, t_compensada] = lsim(G_compensado_mf, rampa, t);

% Plota as respostas calculadas e a referência
hold on
plot(t_original, y_original, 'r--')
plot(t_compensada, y_compensada, 'g-')
plot(t, rampa, 'k:')
title('Comparação da Resposta à Rampa Unitária')
legend('Sistema Original', 'Sistema Compensado', 'Referência')
grid on
hold off
