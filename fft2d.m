function [Pfft] = fft2d(X, range_samples, sin_angle_samples, ifplot)
% fft2d - performs the 2D-FFT algorithm
%
% Inputs:
%   X - one beat data matrix (array length * time sample number)
%   range_samples - a vector consisting of test ranges,
%                   e.g. (0:512-1) * d_R * N / 512
%   sin_angle_samples - a vector consisting of test sin angles, 
%                   e.g. -1 : 2/384: 1 - 2/384
%   ifplot - whether draw the plot or not
%
% Outputs:
%   Pfft - the 2D-FFT specturm

    N_vr = size(X, 1);
    N_t = size(X, 2);
    
    N_angle = size(sin_angle_samples, 2);
    N_range = size(range_samples, 2);
    
    h_window = repmat(hamming(N_vr), [1, N_t]);
    
    Pfft = fftshift(fft2(X .* h_window, N_angle, N_range), 1).' / sqrt(N_vr * N_t);
    
    Pfft = abs(Pfft);
    Pmmax = max(max(Pfft));
    Pfft = 10 * log10(Pfft ./ Pmmax);
    
    if nargin == 4 && ifplot
        get_2dfft_plots(range_samples, sin_angle_samples, Pfft, "Fourier Beamformer", [-15, 0]);
    end
end

