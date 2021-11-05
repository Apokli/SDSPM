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


%     **********************************************************
%        ***------------========START========-----------------****
%     **********************************************************

Data_VR = to_standard_data_cube(Data); % form virtual array matrix
Xr = squeeze(Data(1, :, 1, :)); % not virtual array
X = squeeze(Data_VR(:, 1, :)); % take the first beat

N_angle = K * M * 32;
N_range = N * 2;

angle_samples = -pi / 2 : pi / N_angle : pi / 2 - pi / N_angle;
range_samples = (0 : N_range - 1) * d_R * N / N_range;
sin_angle_samples = -1 : 2 / N_angle: 1 - 2 / N_angle;

d_space = d_rx / lambda;

ifplot = true;

% fft results:
P_without_virtual_array = fft2d(Xr, range_samples, sin_angle_samples, ifplot);
if ifplot 
    saveas(gcf,'Pfft_without_virtual_array','png'); 
end
P_with_virtual_array = fft2d(X, range_samples, sin_angle_samples, ifplot);
if ifplot 
    saveas(gcf,'Pfft_with_virtual_array','png');
end

% 1D angle spectra
Pmusic = music(X, angle_samples, d_space, ifplot);
if ifplot 
    saveas(gcf,'Pmusic','png');
end
PMVDR = MVDR(X, angle_samples, d_space, ifplot);
if ifplot 
    saveas(gcf,'PMVDR','png');
end

% 2D spectra
Pmusicfft = musicfft(X, range_samples, angle_samples, d_space, ifplot);
if ifplot 
    saveas(gcf,'Pmusicfft','png');
end
Pmvdrfft = mvdrfft(X, range_samples, angle_samples, d_space, ifplot);
if ifplot 
    saveas(gcf,'PMVDRfft','png');
end

window_size = [8, 18];
time_coef = B/(Tc * Fs);
Pmusic2d = music2d(X, window_size, range_samples, angle_samples, d_space, f_c, time_coef, ifplot);
if ifplot 
    saveas(gcf,'Pmusic2d','png');
end









