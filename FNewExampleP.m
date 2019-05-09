
% This function simulates a image distorted by a certain rule, and gives  %
% the distorted image as the result.                                      %
% First write date forget.                                                %
% Previous modification date: 2019-04-08                                  %
% All rights reserved to @HelloSYQ                                        %

function result = FNewExampleP(imname,nname,p)

    image_gray = imread(imname);
    image_gray = im2double(image_gray);
    %image_gray = rgb2gray(image_origin);
    image_size = size(image_gray);
    [X,Y] = meshgrid(1:image_size(1),1:image_size(2));
    
    image_kernel = zeros(image_size(1),image_size(2));
    image_distorted = zeros(image_size);
    sigma = 0.5;
%     a = 1;
    
    if mod(image_size(1),2) == 1
        im_c = (image_size(1)-1)/2;
    else
        im_c = image_size(1)/2;
    end
    X1 = X - im_c;
    Y1 = Y - im_c;
    K1 = p(1)*(X1.^2+Y1.^2)+p(2)*(X1.^4+Y1.^4+2*X1.^2.*Y1.^2);
    
    % Calculating the kernel.
    for i = 1:image_size(1)
        for j = 1:image_size(2)
            S = i+K1.*X1;
            T = j+K1.*Y1;
            image_kernel(:,:) = exp(-1/(2*sigma*sigma)*((S-X).^2+(T-Y).^2));
            image_distorted(j,i) = sum(sum(image_gray.*image_kernel));
        end
    end
    
    result = image_distorted/max(max(image_distorted));
    imwrite(result,nname);
end
