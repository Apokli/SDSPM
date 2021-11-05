function [] = get_plot(angle_samples, P, text)
% get_plot - draws the power-angle plot.
%
% Inputs:
%   angle_samples - a vector consisting of test angles
%                   e.g. -pi / 2 : pi / 384 : pi / 2 - pi / 384
%   P - the 1D spectrum
%   text - the title of the plot

    figure()
    spectrum = plot(angle_samples * 180 / pi ,P);
    set(spectrum, 'Linewidth', 2);
    xlabel('angle / бу');
    ylabel('P / dB');
    set(gca, 'XTick', -90:30:90);
    title(text)
    grid on;
end

