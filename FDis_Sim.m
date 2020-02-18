% This function simulates a image distorted by a certain rule, and gives  %
% the distorted image as the result.                                      %
% INPUT:                                                                  % 
% imname: string, name of the source image.                               %
% nname : string, name of the output image.                               %
% p     : 1x2 double array, distortion parameter.                         %
% noise_parameter: double, lambda of poisson noise.                       %
% Noise_scale    : double, scale the value of image and noise maximum.    %
% First write date forget.                                                %
% Previous modification date: 2019-04-08                                  %
% All rights reserved to @HelloSYQ                                        %
% patch 20190528: add noise control                                       %
% patch 20190530: add noise ctrl parameter: ture, false.                  %
% patch 20190603: use strcmp instead of '==' for string compare, cancel   % 
%                 preallocate for image_kernel.                           %
% patch 20190617: add noise sacle parameter.                              %
% patch 20191014: add generating a series of noise images.                %
% patch 20191223: add if statement to reduce the calculation.             %
% patch 20200203: add mode_flag for more simulation requists.             %
% The default location of the noise images are /LAB/git/new_distort/noise %


function result = FDis_Sim(imname,mode_flag,p,FLUX,expand_D,noise_ctrl,noise_parameter)

    img_src = imread(imname);
    img_src = im2double(img_src);
    img_size = size(img_src);
    im_o = zeros(img_size(1)+2*expand_D,img_size(2)+2*expand_D);
    im_o(expand_D+1:img_size(1)+expand_D,expand_D+1:img_size(1)+expand_D) = img_src;
    imo_size = size(im_o);
    
    [X,Y] = meshgrid(1:imo_size(1),1:imo_size(2));
    
    im_distorted = zeros(imo_size);
    sigma = 10;
    
    if mod(imo_size(1),2) == 1
        im_c = (imo_size(1)+1)/2;
    else
        im_c = imo_size(1)/2;
    end
    X1 = X - im_c;
    Y1 = Y - im_c;
    
    pa = -1/(2*sigma^2);
    
% USE mode_flag to run Simulation for different requists.
    switch mode_flag
        % Calculating the distorted kernel and image for single polynomial.
        case 'single_poly'
            disp('call single poly');
            Ks1 = p(1)*X1+p(2)*Y1+p(3)*X1.^2+p(4)*Y1.^2+p(5)*X1.*Y1;
            Ks2 = p(6)*X1.^2+p(7)*Y1.^2+p(8)*X1.*Y1;
            for i = 1:imo_size(1)
                for j = 1:imo_size(2)
                    if im_o(i,j)~=0
                        S = i+Ks1.*(i-im_c)+Ks2.*(i-im_c)^2;
                        T = j;
                        tep1(:,:) = exp(pa*((S-X).*(S-X)));
                        tep2(:,:) = exp(pa*((T-Y).*(T-Y)));
                        norm_ker = tep1.*tep2/sum(tep1(:).*tep2(:));
                        im_distorted = im_distorted+im_o(i,j)*norm_ker;
		    end
                end
            end
        
        % Calculating the distorted kernel and image for multi-polynomials.
        case 'multi_poly'
            disp('call multi poly');
            K1 = p(1)*(X1.^2+Y1.^2)+p(2)*(X1.^4+Y1.^4+2*X1.^2.*Y1.^2)+p(5)*X1.^3;
            K2 = p(3)*(X1.^2+Y1.^2)+p(4)*(X1.^4+Y1.^4+2*X1.^2.*Y1.^2)+p(6)*Y1.^3;
            for i = 1:imo_size(1)
                for j = 1:imo_size(2)
                    if im_o(i,j)~=0
                        S = i+(i-im_c)*K1;
                        T = j+(j-im_c)*K2;
                        tep1(:,:) = exp(pa*((S-X).*(S-X)));
                        tep2(:,:) = exp(pa*((T-Y).*(T-Y)));
                        norm_ker = tep1.*tep2/sum(tep1(:).*tep2(:));
                        im_distorted = im_distorted+im_o(i,j)*norm_ker;
                    end
                end

            end
        
        % Calculating the distorted kernel and image for log-distortions.
        case 'log_sim'
            disp('call log sim');
            K_log1 = p(1)*log(1+p(2)*X1.^2+p(3)*Y1.^2);
            K_log2 = p(4)*log(1+p(5)*X1.^2+p(6)*Y1.^2);
            for i = 1:imo_size(1)
                for j = 1:imo_size(2)
                    if im_o(i,j)~=0
                        S = i+(i-im_c)*K_log1;
                        T = j+(j-im_c)*K_log2;
                        tep1(:,:) = exp(pa*((S-X).*(S-X)));
                        tep2(:,:) = exp(pa*((T-Y).*(T-Y)));
                        norm_ker = tep1.*tep2/sum(tep1(:).*tep2(:));
                        im_distorted = im_distorted+im_o(i,j)*norm_ker;
                    end
                end
            end
    end
    
    if (strcmp(noise_ctrl,'true'))
        Noise = poissrnd(noise_parameter,imo_size(1),imo_size(2));
        img_dist = FLUX*im_distorted+Noise;
    elseif (strcmp(noise_ctrl,'false'))
        img_dist = FLUX*im_distorted;
    else 
        img_dist = 'error!';
    end
    result = img_dist(expand_D+1:img_size(1)+expand_D,expand_D+1:img_size(1)+expand_D);
end
