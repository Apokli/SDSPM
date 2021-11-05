function [data_cube] = to_standard_data_cube(original_4d_cube)
% to_standard_data_cube - reforms the 4d Tx * Rx * slowtime * fasttime
%                         matrix to (Tx * Rx) * slowtime * fasttime matrix,
%                         which is data for the virtual array. 
%
% Inputs:
%   original_4d_cube - the 4d Tx * Rx * slowtime * fasttime matrix.
%
% Outputs:
%   data_cube - the (Tx * Rx) * slowtime * fasttime matrix.

    Ntx = size(original_4d_cube, 1);
    Nrx = size(original_4d_cube, 2);
    Np = size(original_4d_cube, 3);
    Nn = size(original_4d_cube, 4);

    Nvr = Ntx * Nrx;    % number of radar in virtual array

    data_cube = zeros(Nvr, Np, Nn);
    for i = 1:Ntx
        for j = 1:Nrx
            data_cube((i - 1) * Nrx + j, :, :) = original_4d_cube(i, j, :, :);
        end
    end
end

