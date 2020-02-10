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


function result = FExampleP(imname,mode_flag,p,noise_ctrl,noise_parameter,Noise_scale)

    im_o = imread(imname);
    im_o = im2double(im_o);
    image_size = size(im_o);
    [X,Y] = meshgrid(1:image_size(1),1:image_size(2));
    
    im_distorted = zeros(image_size);
    sigma = 10;
    
    if mod(image_size(1),2) == 1
        im_c = (image_size(1)+1)/2;
    else
        im_c = image_size(1)/2;
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
            for i = 1:image_size(1)
                for j = 1:image_size(2)
                    if im_o(i,j)~=0
                        S = i+Ks1.*(i-im_c)+Ks2.*(i-im_c)^2;
                        T = j;
                        tep1(:,:) = exp(pa*((S-X).*(S-X)));
                        tep2(:,:) = exp(pa*((T-Y).*(T-Y)));
                        im_distorted = im_distorted+im_o(i,j)*tep1.*tep2;
                    end
                end
            end
        
        % Calculating the distorted kernel and image for multi-polynomials.
        case 'multi_poly'
            disp('call multi poly');
            K1 = p(1)*(X1.^2+Y1.^2)+p(2)*(X1.^4+Y1.^4+2*X1.^2.*Y1.^2)+p(5)*X1.^3;
            K2 = p(3)*(X1.^2+Y1.^2)+p(4)*(X1.^4+Y1.^4+2*X1.^2.*Y1.^2)+p(6)*Y1.^3;
            for i = 1:image_size(1)
                for j = 1:image_size(2)
                    if im_o(i,j)~=0
                        S = i+(i-im_c)*K1;
                        T = j+(j-im_c)*K2;
                        tep1(:,:) = exp(pa*((S-X).*(S-X)));
                        tep2(:,:) = exp(pa*((T-Y).*(T-Y)));
                        im_distorted = im_distorted+im_o(i,j)*tep1.*tep2;
                    end
                end

            end
        
        % Calculating the distorted kernel and image for log-distortions.
        case 'log_sim'
            disp('call log sim');
            K_log1 = p(1)*log(1+p(2)*X1.^2+p(3)*Y1.^2);
            K_log2 = p(4)*log(1+p(5)*X1.^2+p(6)*Y1.^2);
            for i = 1:image_size(1)
                for j = 1:image_size(2)
                    if im_o(i,j)~=0
                        S = i+(i-im_c)*K_log1;
                        T = j+(j-im_c)*K_log2;
                        tep1(:,:) = exp(pa*((S-X).*(S-X)));
                        tep2(:,:) = exp(pa*((T-Y).*(T-Y)));
                        im_distorted = im_distorted+im_o(i,j)*tep1.*tep2;
                    end
                end
            end
    end

    
    % Calculating the kernel.
%     for i = 1:image_size(1)
%         S = i+K1.*X1;
%         T = i+K1.*Y1;
%         tep1(:,:) = exp(pa*((S-X).*(S-X)));
%         tep2(:,:) = exp(pa*((T-Y).*(T-Y)));
%         temp1(:,i) = reshape(tep1(:,:),[line_size,1]);
%         temp2(:,i) = reshape(tep2(:,:),[line_size,1]);
%     end
%     line_im_o = reshape(im_o,[line_size,1]);
%     toc;

    % Calculating the distorted image.
%     for i = 1:image_size(1)
%         for j = i:image_size(2)
% 	    	image_kernel = temp1(:,i).*temp2(:,j);
%             im_distorted(j,i) = line_im_o'*image_kernel;
%             im_distorted(i,j) = im_distorted(j,i);
%         end
%     end    
    
    
    
    % Add Possion Noise;
    % Possion Noise should be rescaled instead of adding directly.
    % scale of noise to image preset to 1:1e5;
    % Noise_scale set to be input parameter;
    
    if (strcmp(noise_ctrl,'true'))
        Noise = poissrnd(noise_parameter,image_size(1),image_size(2));
        result = (Noise_scale*im_distorted+Noise)/max(max(Noise_scale*im_distorted+Noise));
    elseif (strcmp(noise_ctrl,'false'))
        if max(im_distorted(:)) ~= 0
            result = (im_distorted)/max(im_distorted(:));
        else
            result = im_distorted;
        end
    else 
	result = 'error!';
    end
end
