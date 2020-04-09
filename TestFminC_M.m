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
%        20200224    : Matrix version for fmincon recon test.     %
% Author: HelloSYQ                                                %




function result = TestFminC_M(filename,sourcename,img_src_name,mode_flag,kaisq_flag,FLUX,expand_D,x0,lb,hb,lambda)

    rec_file = load(filename,sourcename);
    img_rec = rec_file.(sourcename);
    img_src = im2double(imread(img_src_name));
    cigma = 10;

    tic;
    fun = @(X)ValueF_M(X,mode_flag,kaisq_flag,FLUX,img_src,img_rec,expand_D,cigma);
    
    A = [];
    b = [];
    Aeq = [];
    beq = [];
    nonlcon=[];
    options = optimoptions('fmincon','Display','iter','Algorithm','sqp');
    result = fmincon(fun,x0,A,b,Aeq,beq,lb,hb,nonlcon,options);
    toc;
    img_tmp = FDis_Sim('testsr.png','multi_poly',result*1e-6,1e5,50,'false',0);
    K2 = sum(sum((img_rec-img_tmp).^2/lambda));
    disp(K2);
end
