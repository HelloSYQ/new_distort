% This function is an optimized function for calculating the     %
% error between the input image and the reconstructed distortion %
% image. Input distortion parameter a_F=[a1,a2], original source %
% image im_o and distorted image im_d, sigma of the PSF.         %
% Output the error of the a_F reconstructed image and distorted  %
% image.                                                         %
% 20190912 RECENT UPDATES:                                       %
% 1. reduce the main loop to 1.                                  %


function result = ValueF(p,im_o,im_d,cigma)

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
    Y1 = Y - im_c;i

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
                im_r = im_r+im_o(i,j)*tep1.*tep2;
            end
        end
    end
    
    % calculating value function
    v_s = (im_d - im_r).^2);
    Value = sum(v_s(:));
    result = Value;
end
