% This function is designed to generate a series of images with a range   %
% of noise.                                                               %
% Rely : FExampleP.                                                       %
% INPUT:                                                                  %
% imname: string, name of the source image.                               %
% nname : string, name of the output image.                               %
% p     : 1x2 double array, distortion parameter.                         %
% noise_parameter: 1xN double array, lambda of poisson noise.             %
% Noise_scale    : double, scale the value of image and noise maximum.    %
% Num   : integer, number of the noise images.                            %
% OUTPUT:                                                                 %
% A group of noise images, name of the noise image is 'Noise_Iamge_No'.   %
% Version: 2019-10-14                                                     %
% Author : HelloSYQ                                                       %
% The default location of the noise images are /LAB/git/new_distort/noise %

function result = NoiseImageGen(imname,p,noise_parameter,Noise_scale,Num)
    Image_Temp = TempGen(imname,p);
    image_size = size(Image_Temp);
    for i = 1:Num
	Noise = poissrnd(noise_parameter(i),image_size(1),image_size(2));
    	Noise_Image = (Noise_scale*Image_Temp+Noise)/max(max(Noise_scale*Image_Temp+Noise));
	Image_Name = ['./noise/Noise_Image',num2str(i),'.png'];
	imwrite(Noise_Image,Image_Name);
    end
end
