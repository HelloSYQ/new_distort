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
            Ks1 = p(1)*U1+p(2)*V1+p(3)*U1.^2+p(4)*V1.^2+p(5)*U1.*V1;
            Ks2 = p(6)*U1.^2+p(7)*V1.^2+p(8)*U1.*V1;
            for x = 1:imo_size(1)
                for y = 1:imo_size(2)
                    if im_o(x,y)~=0
                        S = U1+Ks1.*(x-im_c)+Ks2.*(x-im_c)^2;
                        T = V1;
                        tep1(:,:) = exp(pa*((S-(x-im_c)).*(S-(x-im_c))));
                        tep2(:,:) = exp(pa*((T-(y-im_c)).*(T-(y-im_c))));
                        norm_tep = sum(tep1(:).*tep2(:));
                        if (norm_tep~= 0)
                            norm_ker = tep1.*tep2/norm_tep;
                        else
                            norm_ker = tep1.*tep2;
                        end
                        im_distorted = im_distorted+im_o(x,y)*norm_ker;
                    end
                end
            end
        
        % Calculating the distorted kernel and image for multi-polynomials.
	case 'multi_poly'
            disp('call multi poly');
            K1 = p(1)*U1+p(2)*V1;
            K2 = p(3)*U1+p(4)*V1+p(5)*U1.^2+p(6)*V1.^2;
            K3 = p(7)*U1+p(8)*V1;
            K4 = p(9)*U1+p(10)*V1+p(11)*U1.^2+p(12)*V1.^2;
            for x = 1:imo_size(1)
                for y = 1:imo_size(2)
                    if im_o(x,y)~=0
                        S = U1+(x-im_c)^2*K1+(x-im_c)*K2;
                        T = V1+(y-im_c)^2*K3+(y-im_c)*K4;
                        tep1(:,:) = exp(pa*((S-(x-im_c)).*(S-(x-im_c))));
                        tep2(:,:) = exp(pa*((T-(y-im_c)).*(T-(y-im_c))));
                        norm_tep = sum(tep1(:).*tep2(:));
                        if (norm_tep~= 0)
                            norm_ker = tep1.*tep2/norm_tep;
                        else
                            norm_ker = tep1.*tep2;
                        end
                        im_distorted = im_distorted+im_o(x,y)*norm_ker;
                    end
                end

            end
        
        % Calculating the distorted kernel and image for log-distortions.
        case 'log_sim'
            disp('call log sim');
            K_log1 = p(1)*log(1+p(2)*U1.^2+p(3)*V1.^2);
            K_log2 = p(4)*log(1+p(5)*U1.^2+p(6)*V1.^2);
            for x = 1:imo_size(1)
                for y = 1:imo_size(2)
                    if im_o(x,y)~=0
                        S = U1+(x-im_c)*K_log1;
                        T = V1+(y-im_c)*K_log2;
                        tep1(:,:) = exp(pa*((S-(x-im_c)).*(S-(x-im_c))));
                        tep2(:,:) = exp(pa*((T-(y-im_c)).*(T-(y-im_c))));
                        norm_tep = sum(tep1(:).*tep2(:));
                        if (norm_tep~= 0)
                            norm_ker = tep1.*tep2/norm_tep;
                        else
                            norm_ker = tep1.*tep2;
                        end
                        im_distorted = im_distorted+im_o(x,y)*norm_ker;
                    end
                end
            end
    end


    % Poisson Noise
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
