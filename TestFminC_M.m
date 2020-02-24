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




function result = TestFminC_M(filename,sourcename,img_src_name,FLUX,expand_D,x0,lb,hb)

    rec_file = load(filename,sourcename);
    img_rec = rec_file.(sourcename);
    img_src = im2double(imread(img_src_name));
    cigma = 10;

    tic;
    fun = @(X)ValueF_M(X,FLUX,img_src,img_rec,expand_D,cigma);
    
    A = [];
    b = [];
    Aeq = [];
    beq = [];
    nonlcon=[];
    options = optimoptions('fmincon','Display','iter','Algorithm','sqp');
    result = fmincon(fun,x0,A,b,Aeq,beq,lb,hb,nonlcon,options);
    toc;
end
