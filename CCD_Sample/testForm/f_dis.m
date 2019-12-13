
% This function calculates a integral distribution of f.m %

function result = f_dis(size,gap)
    result = zeros(size);
    for i = 1:2*size(1)+1
        for j = 1:2*size(2)+1
            i1 = i - size(1) - 1;
            j1 = j - size(2) - 1;
            result(i,j) = integral2(@f,i1-gap,i1+gap,j1-gap,j1+gap);
        end
    end
end