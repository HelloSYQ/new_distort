%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                      %
% This function calculates the sampling matrix for a   %
% given 1D series.                                     %
% Input:                                               %
%     test_length: integer, length of the input series %
% Output:                                              %
%     sampling_mat: NxN matrix, N = test_length        %
% Author: Hellosyq ========== Date 20191209            %
% Version 1.0                                          %
%                                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function result = sampling_mat_calc(test_length)
    G = zeros(test_length,test_length);
    for i = 1:test_length
        for j = 1:test_length
            g = @(x) sin(pi*(x-i))./(pi*(x-i));
            G(i,j) = integral(g,j-0.5,j+0.5);
        end
    end
    result = G;
end