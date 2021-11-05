function [Pmusicfft, conds] = musicfft(X, range_samples, angle_samples, d_space, ifplot)
% musicfft - performs the FFT on range and MUSIC on angle
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
    
    conds = [];
    N_vr = size(X, 1);
    N_angle = size(angle_samples, 2);
    N_range = size(range_samples, 2);
    N_w = 12;
    N_range_fft = N_w * N_range;
    
    ffted_data = fft(X.', N_range_fft).';
    Pmusicfft = zeros(N_range, N_angle);

    for nr = 1 : N_range
        seg_X = ffted_data(:, (nr - 1) * N_w + 1 : (nr - 1) * N_w + N_w);
        
        Rx = seg_X * seg_X' / N_w;
        [evs, evas] = eig(Rx);
        [evas_sorted,index] = sort(diag(evas),'descend');
        evs_sorted = evs(:,index);
        
        NV = evs_sorted(:, evas_sorted < 2);
        
        d_samples = 0 : d_space : (N_vr - 1) * d_space;
        Pmusic = zeros(1, N_angle);
        for na =  1 : N_angle
            A = exp(1i * 2 * pi * sin(angle_samples(na)) * d_samples).';
            Pmusic(na) = 1 / (A' * NV * NV' * A);
        end
        
        Pmusicfft(nr, :) = Pmusic;
    end
    
    Pmusicfft = abs(Pmusicfft);
    Pmmax = max(max(Pmusicfft));
    Pmusicfft = 10 * log10(Pmusicfft ./ Pmmax); 
    
    if nargin == 5 && ifplot
        get_2d_plots(range_samples, angle_samples, Pmusicfft, "MUSIC-FFT spectrum");    
    end
end

