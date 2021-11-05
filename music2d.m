function [Pmusic] = music2d(X, window_size, range_samples, angle_samples, d_space, fc, time_coef, ifplot)
% music2d - performs the 2D-MUSIC algorithm
%
% Inputs:
%   X - one beat data matrix (virtual array length * time sample number)
%   window_size - window size for sampling the data matrix, e.g. [4, 4]
%   range_samples - a vector consisting of test ranges,
%                   e.g. (0:512-1) * d_R * N / 512
%   angle_samples - a vector consisting of test angles, 
%                   e.g. -pi / 2 : pi / 384 : pi / 2 - pi / 384
%   d_space - element space / lambda
%             e.g. 0.5
%   fc - carrier frequency
%   time_coef - coeficient related to time, i.e. bandwidth / (chirp duration * sampling frequency)
%   ifplot - whether draw the plot or not
%
% Outputs:
%   Pmusic - the 2D-MUSIC pseudo-specturm
        
    d_space = d_space * 3e8 / fc;
    N_vr = size(X, 1);
    N_t = size(X, 2);

    l1 = window_size(1);
    l2 = window_size(2);
    
    p1 = N_vr - l1 + 1;
    p2 = N_t - l2 + 1;
    
    % form X tilde mat
    
    X_t = zeros(l1 * l2, p1 * p2);
    
    for j = 1 : p1
        for i = 1 : p2
            sub_mat = X(j : (j + l1 - 1), i : (i + l2 -1));
            sub_mat = sub_mat.';
            sub_vec = sub_mat(:);
            X_t(:, (j - 1) * p2 + i) = sub_vec;
        end
    end
    
    % smoothing
    
    J = flip(eye(l1 * l2));
    Rx = X_t * X_t';
    C = (Rx + J * Rx * J) ./ (2 * p1 * p2);
    
    % ----------------------------MUSIC----------------------------------
    
    % eigenvalue decomposition
    
    [evs, evas] = eig(C);
    [evas_sorted,index] = sort(diag(evas),'descend');
    evs_sorted = evs(:,index);
    
    % determine noise space
    
    NV = evs_sorted(:, evas_sorted < 2);  % simple threshold
    
    % spectrum estimation
    
    N_angle = size(angle_samples, 2);
    N_range = size(range_samples, 2);
    
    Pmusic = zeros(N_range, N_angle);
    
    for nr = 1 : N_range
        for na = 1 : N_angle
            A = zeros(l1 * l2, 1);
            for s = 1 : l1
                r = (range_samples(nr) + (s - 1) * d_space * sin(angle_samples(na)) / 2) * 2 / 3e8;
                A((s - 1) * l2 + (1:l2), 1) = exp(-1i * 2 * pi * (fc * r + (0 : l2-1) * time_coef * r));
            end
            Pmusic(nr, na) = 1 / (A' * NV * NV' * A);
        end
    end
    
    % normalize
    
    Pmusic = abs(Pmusic);
    Pmmax = max(max(Pmusic));
    Pmusic = 10 * log10(Pmusic ./ Pmmax); 
    
    if nargin == 8 && ifplot
        get_2d_plots(range_samples, angle_samples, Pmusic, "2D-MUSIC spectrum");    
    end
end
            
    
    
    
    
    