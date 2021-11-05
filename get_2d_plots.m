function [] = get_2d_plots(range_samples, angle_samples, P, text, color_range)
% get_2d_plots - draws the 2d plots in range-angle coordinates and in
%                Cartesian coordinates.
%
% Inputs:
%   range_samples - a vector consisting of test ranges,
%                   e.g. (0:512-1) * d_R * N / 512
%   angle_samples - a vector consisting of test angles
%                   e.g. -pi / 2 : pi / 384 : pi / 2 - pi / 384
%   P - the 2D spectrum
%   text - the title of the plot
%   color_range - the range of dBs which is applies a color map,
%                   e.g. [-40, 5]
    
% range-angle coordinates
    figure();
    subplot(1,2,1)
    imagesc(angle_samples * 180 / pi, range_samples, P)
    xlabel('angle / бу')
    ylabel('range / m')
    axis xy
    
    if nargin == 5
        caxis(color_range)
    end
    
    hcb = colorbar;
    hcb.Title.String = 'dB'; 
    title(text)
    
% Cartesian Coordinates
    [rho, theta] = meshgrid(range_samples, angle_samples);
    [X_coor, Y_coor] = pol2cart(theta, rho);

    subplot(1,2,2)
    s = pcolor(X_coor, Y_coor, P.');
    s.FaceColor = 'interp';
    axis image
    view(2);
    shading interp;
    
    if nargin == 5
        caxis(color_range);
        zlim(color_range);
    end
    
    grid off;
    ylabel('x, m')
    xlabel('y, m')
    title('Cartesian coordinates')
    hcb = colorbar;
    hcb.Title.String = 'dB'; 
end

