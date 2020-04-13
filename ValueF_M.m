% This function is an optimized function for calculating the     %
% error between the input image and the reconstructed distortion %
% image. Input distortion parameter a_F=[a1,a2], original source %
% image im_o and distorted image im_d, sigma of the PSF.         %
% Output the error of the a_F reconstructed image and distorted  %
% image.                                                         %
% 20190912 RECENT UPDATES:                                       %
% 1. reduce the main loop to 1.                                  %
% 2. note: im_src is the source image directly read from         %
% 20200413 RECENT UPDATES:                                       %
% 1. model bug fixed.                                            %



function result = ValueF_M(p,mode_flag,kaisq_flag,FLUX,img_src,im_d,expand_D,cigma)

    img_size = size(img_src);
    im_o = zeros(img_size(1)+2*expand_D,img_size(2)+2*expand_D);
    im_o(expand_D+1:img_size(1)+expand_D,expand_D+1:img_size(1)+expand_D) = img_src;
    image_size = size(im_o);
    im_s = zeros(image_size);
    [U,V] = meshgrid(1:image_size(1),1:image_size(2));

    % center of the image
    if mod(image_size(1),2) == 1
        im_c = (image_size(1)+1)/2;
    else
        im_c = image_size(1)/2;
    end
    
    U1 = U - im_c;
    V1 = V - im_c;
    
    %SCALE = [1e-6,1e-12,1e-6,1e-12,1e-8,1e-8];
    SCALE = 1e-6;
    p = SCALE.*p;

    % distortion model
    pa = -1/(2*cigma^2);

    switch mode_flag
    % muti-poly model
	    case 'muti-poly'
    	    K2 = p(1)*(U1.^2+V1.^2)+p(2)*(U1.^4+V1.^4+2*U1.^2.*V1.^2)+p(5)*U1.^3;
           	K4 = p(3)*(U1.^2+V1.^2)+p(4)*(U1.^4+V1.^4+2*U1.^2.*V1.^2)+p(6)*V1.^3;
            K1 = 0;
	    	K3 = 0;

    % single-poly model
	    case 'single-poly'
            K2 = p(1)*U1+p(2)*V1+p(3)*U1.^2+p(4)*V1.^2+p(5)*U1.*V1;
            K4 = p(6)*U1.^2+p(7)*V1.^2+p(8)*U1.*V1;
            K1 = 0;
            K3 = 0;

    % whole-poly model
	    case 'whole-poly'
            K1 = p(1)*U1+p(2)*V1;
            K2 = p(3)*U1+p(4)*V1+p(5)*U1.^2+p(6)*V1.^2;
            K3 = p(7)*U1+p(8)*V1;
            K4 = p(9)*U1+p(10)*V1+p(11)*U1.^2+p(12)*V1.^2;
    end

    % calculating distorted image
    for x = 1:image_size(1)
        for y = 1:image_size(2)
            if im_o(x,y)~=0
                S = U1+(x-im_c)^2*K1+(x-im_c)*K2;
                T = V1+(y-im_c)^2*K3+(y-im_c)*K4;
                tep1(:,:) = exp(pa*((S-(x-im_c)).*(S-(x-im_c))));
                tep2(:,:) = exp(pa*((T-(y-im_c)).*(T-(y-im_c))));
                norm_ker = tep1.*tep2/sum(tep1(:).*tep2(:));
                im_s = im_s+im_o(x,y)*norm_ker;
            end
        end
    end

    % Add Flux to distortion image
    im_r = FLUX*im_s(expand_D+1:img_size(1)+expand_D,expand_D+1:img_size(1)+expand_D);

    % debug info
    % disp(max(im_r(:)));
    % disp(max(im_d(:)));

    % calculate the mean noise signal
%    mean_noise = (sum(im_d(:)) - FLUX*sum(img_src(:)))/(img_size(1)*img_size(2));
%    disp(mean_noise);

    % calculating value function
    if (strcmp(kaisq_flag,'true'))
        v_s = (im_d - im_r).^2/im_r;
    else if (strcmp(kaisq_flag,'false'))
	    v_s = (im_d - im_r).^2;
        else
            disp('no kaisq_flag');
        end
    end
    Value = sum(v_s(:));
    disp(Value);
    result = Value;
end
