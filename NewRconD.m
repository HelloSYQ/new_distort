% This function is a reconstruction program for Fredholm    %
% Integral model.                                           %
% INPUT:                                                    %
% range1,range2 : integer, range of the searching space;    %
% step          : double, step length for search            %
% imn1          : double array, input image.                %
% imn2          : double array, input template.             %
% OUTPUT:                                                   %
% reconstructed parameter, 1x2 integer array.               %
% DATE 2019-05-28 ======= AUTHOR HELLOSYQ                   %


function result = NewRconD(range1,range2,step,imn1,imn2)
    
    im_o = im2double(imread(imn1));
    im_d = im2double(imread(imn2));
    min = 10^4;
    sigma = 0.5;
    for a1 = range1:range2
        for a2 = range1:range2
    	    a = step*[a1,a2];
	    temp = FdnewValueF(a,im_o,im_d,sigma);
	    disp(temp);
            if temp<min
                min = temp;
                pos = [a1,a2];
            end
        end
    end
    result = pos;
end
