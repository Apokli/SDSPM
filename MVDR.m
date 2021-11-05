function [PMVDR] = MVDR(X, angle_samples, d_space, ifplot)
% MVDR - performs MVDR to estimate angles
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
%   Pmusic - the MVDR pseudo-specturm

    N_vr = size(X, 1);
    N_t = size(X, 2);
    d_samples = 0 : d_space : (N_vr - 1) * d_space;

    N_angle = size(angle_samples, 2);
    PMVDR = zeros(1, N_angle);

    Rx = X * X' / N_t;

    for na = 1 : N_angle
        ev = exp(1i * 2 * pi * d_samples.' * sin(angle_samples(na)));
        PMVDR(na) = N_vr / (ev' / Rx * ev);
    end

    PMVDR = abs(PMVDR);
    Pmmax = max(PMVDR);
    PMVDR = 10 * log10(PMVDR / Pmmax); 
    
    if nargin ==4 && ifplot
        get_plot(angle_samples, PMVDR, "MVDR spectrum");
    end
end

