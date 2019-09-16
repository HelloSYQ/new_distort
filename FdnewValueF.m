% This function is an optimized function for calculating the     %
% error between the input image and the reconstructed distortion %
% image. Input distortion parameter a_F=[a1,a2], original source %
% image im_o and distorted image im_d, sigma of the PSF.         %
% Output the error of the a_F reconstructed image and distorted  %
% image.                                                         %
% 20190912 RECENT UPDATES:                                       %
% 1. reduce the main loop to 1.                                  %
% 2. set a log Value Function to make it sharper in ROI.         %


function result = FdnewValueF(a_F,im_o,im_d,cigma)

    image_size = size(im_o);
    im_r = zeros(image_size);
    [X,Y] = meshgrid(1:image_size(1),1:image_size(2));

    % center of the image
    if mod(image_size(1),2) == 1
        im_c = (image_size(1)+1)/2;
    else
        im_c = image_size(1)/2;
    end
    
    X1 = X - im_c;
    Y1 = Y - im_c;
	
    SCALE = 1e-12;
    a_F = a_F*SCALE;
    % distortion parameter
    K1 = a_F(1)*(X1.^2+Y1.^2)+a_F(2)*(X1.^4+Y1.^4+2*X1.^2.*Y1.^2);
    pa = -1/(2*cigma*cigma);
    
    % time consuming
    % tic;
    temp1 = zeros(image_size(1)*image_size(2),image_size(1));
    temp2 = zeros(image_size(1)*image_size(2),image_size(1));
    line_size = image_size(1)*image_size(2);
    % calculateing the linear distortin kernel
    for i = 1:image_size(1)
        S = i+K1.*X1;
	T = i+K1.*Y1;
        tep1(:,:) = exp(pa*((S-X).*(S-X)));
        tep2(:,:) = exp(pa*((T-Y).*(T-Y)));
        temp1(:,i) = reshape(tep1(:,:),[line_size,1]);
        temp2(:,i) = reshape(tep2(:,:),[line_size,1]);
    end
    line_im_o = reshape(im_o,[1,line_size]);
	
    tic;
    % calculting the distortion image
    for i = 1:image_size(1)
        image_kernel = temp1(:,i).*temp2;
        im_r(i,:) = (line_im_o*image_kernel);
    end
    toc;
    im_r = im_r'/(max(max(im_r)));
    Value = sum(sum((im_d-im_r).^2));
    result = Value;
%    result = im_r;
end
