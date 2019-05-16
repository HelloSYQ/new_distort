% This function finds the most probable polynomial parameter for point %
% reconstruction model.                                                %
% input: range: 4-element vector, int, range(1), range(2) range of     %
% first prameter, range(3), range(4), range of second parameter.       %
% step: double, step of the searching.                                 %
% imn1: string, name of the source image.                              %
% imn2: string, name of the distorted image.                           %
% output: double, 2 polynomial parameters.                             %
% Date: 2019-05-09 ======== Author: Hellosyq                           %

function result = De_pointResD(range_m,step1,step2,imn1,imn2)
    
    im_o = im2double(imread(imn1));
    im_d = im2double(imread(imn2));
    
    mini = 10^4;
    % main calculation 
    for i = range_m(1):range_m(2);
        for j = range_m(3):range_m(4)
            k = [i*step1,j*step2];
            im_new = ext_pointDis(im_o,k);
            vF = sum(sum((im_d-im_new).^2));
            if vF <= mini
                kout = k;
		disp(mini);
		disp(kout);
                mini = vF;
	    end
        end
    end

    result = kout;
end
