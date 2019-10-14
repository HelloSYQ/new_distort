% This function is designed to run the reconstruction and provide %
% target images, including reconstruction result image and error  %
% image.                                                          %
% This function relies on TestFminC.m, FdnewValueF.m.             %
% Input:                                                          %
%        source_image: 2D double image                            %
%        template    : 2D double distortion template image        %
%        x0          : 1x2 double, initial value for fmincon      %
%        lb          : 1x2 double, low bound of fmincon boundry   %
%        hb          : 1x2 double, high bound of fmincon boundry  %
% Output:                                                         %
%        reconstruction result image: real image.                 %
%        error image                : real image.                 %
%        reconstructed parameter    : 1x2 real vector             %
% Versions: 2019-10-14 create                                     %
% Author  : HelloSYQ                                              %

function result = RecImage(source_image,template,x0,lb,hb)



