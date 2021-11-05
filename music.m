function [Pmusic] = music(X, angle_samples, d_space, ifplot)
% music - performs MUSIC to estimate angles
%
% Inputs:
%   X - one beat data matrix (array length * time sample number)
%   angle_samples - a vector consisting of test angles, 
%                   e.g. -pi / 2 : pi / 384 : pi / 2 - pi / 384
%   d_space - element space / lambda
%             e.g. 0.5
%   ifplot - whether draw the plot or not
%
% Outputs:
%   Pmusic - the MUSIC pseudo-specturm

    N_vr = size(X, 1);
    N_t = size(X, 2);
    d_samples = 0 : d_space : (N_vr - 1) * d_space;

    Rx = X * X' / N_t;
    [evs, evas] = eig(Rx);
    [evas_sorted,index] = sort(diag(evas),'descend');
    evs_sorted = evs(:,index);

    NV = evs_sorted(:, evas_sorted < 2);  % simple threshold

    N_angle = size(angle_samples, 2);
    Pmusic = zeros(1, N_angle);

    for n = 1:N_angle
        A = exp(1i * 2 * pi * d_samples.' * sin(angle_samples(n)));
        Pmusic(n) = 1 / (A' * NV * NV' * A);
    end

    Pmusic = abs(Pmusic);
    Pmmax = max(Pmusic);
    Pmusic = 10 * log10(Pmusic / Pmmax); 
    
    if nargin == 4 && ifplot
        get_plot(angle_samples, Pmusic, "MUSIC spectrum");
    end
end
