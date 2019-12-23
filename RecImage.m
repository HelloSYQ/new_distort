% This function is designed to run the reconstruction over a      %
% series of noisy images and provide target images, including     %
% reconstruction result image and error image.                    %
% This function relies on TestFminC.m, FdnewValueF.m.             %
% Input:                                                          %
%        file_path   : file address that contains N noisy images  %
%		       to be reconstructed                        %	
%        template    : 2D double distortion template image        %
%        x0          : 1x2 double, initial value for fmincon      %
%        lb          : 1x2 double, low bound of fmincon boundry   %
%        hb          : 1x2 double, high bound of fmincon boundry  %
% Output:                                                         %
%        reconstruction result image: real image.                 %
%        error image                : real image.                 %
%        reconstructed parameter    : Nx2 real vector             %
% Versions: 2019-10-14 create                                     %
% Author  : HelloSYQ                                              %

function result = RecImage(file_path,img_src,x0,lb,hb)
    Img_Src = im2double(imread(img_src));
    Img_Size = size(Img_Src);
    Img_List = dir(strcat(file_path,'*.png'));
    Img_Num = length(Img_List);
    Img_Rec = cell(3,Img_Num);
    Img = zeros(Img_Num,Img_Size(1),Img_Size(2));
    
    % reading all images to be reconstructed in double.
    for j = 1:Img_Num
	img_name = Img_List(j).name;
	Img(j,:,:) = im2double(imread(strcat(file_path,img_name)));
    end
    % finding the polynomial parameters using 'FMINCON' function
    SCALE = 1e-12;
    for j = 1:Img_Num
	Img_Temp = squeeze(Img(j,:,:));
	rec_para = Img_RecM(Img_Src,Img_Temp,x0,lb,hb);
	Img_Rec(3,j) = {rec_para};
	img_tep2 = TempGen(Img_Src,rec_para*SCALE);
	Img_Rec(1,j) = {img_tep2};
	Img_Rec(2,j) = {img_tep2 - Img_Temp};
    end

    result = Img_Rec;
end



