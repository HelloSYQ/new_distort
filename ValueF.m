% This function is an optimized function for calculating the     %
% error between the input image and the reconstructed distortion %
% image. Input distortion parameter a_F=[a1,a2], original source %
% image im_o and distorted image im_d, sigma of the PSF.         %
% Output the error of the a_F reconstructed image and distorted  %
% image.                                                         %
% 20190912 RECENT UPDATES:                                       %
% 1. reduce the main loop to 1.                                  %


function result = ValueF(p,img_src,im_d,expand_D,cigma)

    img_src = im2double(img_src);
    img_size = size(img_src);
    im_o = zeros(img_size(1)+2*expand_D,img_size(2)+2*expand_D);
    im_o(expand_D+1:img_size(1)+expand_D,expand_D+1:img_size(1)+expand_D) = img_src;
    image_size = size(im_o);
    im_s = zeros(image_size);
    [X,Y] = meshgrid(1:image_size(1),1:image_size(2));

    % center of the image
    if mod(image_size(1),2) == 1
        im_c = (image_size(1)+1)/2;
    else
        im_c = image_size(1)/2;
    end
    
    X1 = X - im_c;
    Y1 = Y - im_c;
    
    SCALE = [1e-6,1e-12,1e-6,1e-12,1e-8,1e-8];
    p = SCALE.*p;

    % distortion model
    pa = -1/(2*cigma^2);
    K1 = p(1)*(X1.^2+Y1.^2)+p(2)*(X1.^4+Y1.^4+2*X1.^2.*Y1.^2)+p(5)*X1.^3;
    K2 = p(3)*(X1.^2+Y1.^2)+p(4)*(X1.^4+Y1.^4+2*X1.^2.*Y1.^2)+p(6)*Y1.^3;
    
    % calculating distorted image
    for i = 1:image_size(1)
        for j = 1:image_size(2)
            if im_o(i,j)~=0
                S = i+(i-im_c)*K1;
                T = j+(j-im_c)*K2;
                tep1(:,:) = exp(pa*((S-X).*(S-X)));
                tep2(:,:) = exp(pa*((T-Y).*(T-Y)));
                norm_ker = tep1.*tep2/sum(tep1(:).*tep2(:));
		im_s = im_s+im_o(i,j)*norm_ker;
            end
        end
    end
    im_r = im_s(expand_D+1:img_size(1)+expand_D,expand_D+1:img_size(1)+expand_D);
    
    % calculate the mean noise signal
    mean_noise = (sum(im_d(:)) - sum(img_src(:)))/(image_size(1)*image_size(2));

    % calculating value function
    v_s = (im_d - im_r - mean_noise).^2;
    Value = sum(v_s(:));
    result = Value;
end
