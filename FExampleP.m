
% This function simulates a image distorted by a certain rule, and gives  %
% the distorted image as the result.                                      %
% INPUT:                                                                  % 
% imname: string, name of the source image.                               %
% nname : string, name of the output image.                               %
% p     : 1x2 double array, distortion parameter.                         %
% noise_parameter: double, lambda of poisson noise.                       %
% First write date forget.                                                %
% Previous modification date: 2019-04-08                                  %
% All rights reserved to @HelloSYQ                                        %
% patch 20190528: add noise control                                       %
% patch 20190530: add noise ctrl parameter: ture, false.                  %


function result = FExampleP(imname,nname,p,noise_ctrl,noise_parameter)

    im_o = imread(imname);
    im_o = im2double(im_o);
    %image_gray = rgb2gray(image_origin);
    image_size = size(im_o);
    [X,Y] = meshgrid(1:image_size(1),1:image_size(2));
    
    image_kernel = zeros(image_size(1),image_size(2));
    im_distorted = zeros(image_size);
    sigma = 0.5;
    
    if mod(image_size(1),2) == 1
        im_c = (image_size(1)+1)/2;
    else
        im_c = image_size(1)/2;
    end
    X1 = X - im_c;
    Y1 = Y - im_c;
    tic; 
    K1 = p(1)*(X1.^2+Y1.^2)+p(2)*(X1.^4+Y1.^4+2*X1.^2.*Y1.^2);
    temp1 = zeros(image_size(1)*image_size(2),image_size(1));
    temp2 = zeros(image_size(1)*image_size(2),image_size(1));
    line_size = image_size(1)*image_size(2);
    pa = -1/(2*sigma^2);

    % Calculating the kernel.
    for i = 1:image_size(1)
        S = i+K1.*X1;
        T = i+K1.*Y1;
        tep1(:,:) = exp(pa*((S-X).*(S-X)));
        tep2(:,:) = exp(pa*((T-Y).*(T-Y)));
        temp1(:,i) = reshape(tep1(:,:),[line_size,1]);
        temp2(:,i) = reshape(tep2(:,:),[line_size,1]);
    end
    line_im_o = reshape(im_o,[line_size,1]);

    % Calculating the distorted image.
    for i = 1:image_size(1)
        for j = i:image_size(2)
            image_kernel = temp1(:,i).*temp2(:,j);
            im_distorted(j,i) = line_im_o'*image_kernel;
            im_distorted(i,j) = im_distorted(j,i);
        end
    end
    toc;
    % Add Poisson Noise;
    if (noise_ctrl == 'true')
        Noise = poissrnd(noise_parameter,image_size(1),image_size(2));
        result = (im_distorted+Noise)/max(max(im_distorted+Noise));
    else
        result = (im_distorted+Noise)/max(max(im_distorted+Noise));
    end
    imwrite(result,nname);
end
