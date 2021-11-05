function [Pmvdrfft] = mvdrfft(X, range_samples, angle_samples, d_space, ifplot)
% mvdrfft - performs the FFT on range and MVDR on angle
%
% Inputs:
%   X - one beat data matrix (virtual array length * time sample number)
%   range_samples - a vector consisting of test ranges,
%                   e.g. (0:512-1) * d_R * N / 512
%   angle_samples - a vector consisting of test angles, 
%                   e.g. -pi / 2 : pi / 384 : pi / 2 - pi / 384
%   d_space - element space / lambda
%             e.g. 0.5
%   ifplot - whether draw the plot or not
%
% Outputs:
%   Pmusicfft - the 2D pseudo-specturm

    N_vr = size(X, 1);
    N_angle = size(angle_samples, 2);
    N_range = size(range_samples, 2);
    N_w = 24;
    N_range_fft = N_w * N_range;
    
    ffted_data = fft(X.', N_range_fft).';
    Pmvdrfft = zeros(N_range, N_angle);

    for nr = 1 : N_range
        seg_X = ffted_data(:, (nr - 1) * N_w + 1 : (nr - 1) * N_w + N_w);
        
        Rx = seg_X * seg_X' / N_w;
        [evs, evas] = eig(Rx);
        inv_evas = inv(evas + eps);
        inv_evs = inv(evs);
        
        d_samples = 0 : d_space : (N_vr - 1) * d_space;
        PMVDR = zeros(1, N_angle);
        for na = 1 : N_angle
            A = exp(1i * 2 * pi * d_samples * sin(angle_samples(na))).';
            PMVDR(na) = N_vr / (A' * evs * inv_evas * inv_evs * A);
        end        
        Pmvdrfft(nr, :) = PMVDR;
    end
    
    Pmvdrfft = abs(Pmvdrfft);
    Pmmax = max(max(Pmvdrfft));
    Pmvdrfft = 10 * log10(Pmvdrfft ./ Pmmax); 
    
    if nargin == 5 && ifplot
        get_2d_plots(range_samples, angle_samples, Pmvdrfft, "MVDR-FFT spectrum");    
    end
end



