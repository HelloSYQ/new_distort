
% This function tests the 'FMINCON' with Fredholm Reconstruction. %
% Input:                                                          %
%        source_image: 2D double image                            %
%        template    : 2D double distortion template image        %
%        x0          : 1x2 double, initial value for fmincon      %
%        lb          : 1x2 double, low bound of fmincon boundry   %
%        hb          : 1x2 double, high bound of fmincon boundry  %
% Output:                                                         %
%        reconstruction value: 1x2 double                         %
% Versions:                                                       %
%        20190916: Add comments for this function. Add a time     %
%                  consumer in the function.                      %
% Author: HelloSYQ                                                %




function result = TestFminC(source_image,template,FLUX,expand_D,x0,lb,hb)

    tic;
    im_o = im2double(imread(source_image));
    im_d = im2double(imread(template));
    cigma = 10;
    fun = @(X)ValueF(X,FLUX,im_o,im_d,expand_D,cigma);
    
    A = [];
    b = [];
    Aeq = [];
    beq = [];
    nonlcon=[];
    options = optimoptions('fmincon','Display','iter','Algorithm','sqp');
    result = fmincon(fun,x0,A,b,Aeq,beq,lb,hb,nonlcon,options);
    toc;
end
