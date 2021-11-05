clear
clc
%
%% load radar_data
% Data: data matrix  
% For other variables see explanations below

load('Radar_data_2021')

K = settings.K;         % Tx array elements
M = settings.M;         % Rx array elements
P = settings.P;         % pulses / slow-time
f_c = settings.f_c;     % carrier frequency
Fs = settings.Fs;       % ADC sampling freq
Tc = settings.Tc;       % chirp / sweep duration
B = settings.B;         % chirp / sweep bandwidth
d_rx = settings.d_rx;   % Rx array elements spacing
d_tx = settings.d_tx;   % Tx array elements spacing

c = 3e8;                % light speed
lambda = c/f_c;         % wave length
S = B /Tc;              % chirp rate

d_R = c / (2*B);        % range resolution
N = Tc * Fs;            % number of fast-time samples per chirp

% Data_cube K x M x P x N
kk = reshape(0:K-1, [K, 1, 1, 1]); % Tx
mm = reshape(0:M-1, [1, M, 1, 1]); % Rx
pp = reshape(0:P-1, [1, 1, P, 1]); % Slow-time / pulse/ snapshot
nn = reshape(0:N-1, [1, 1, 1, N]); % Fast-time /beat signal