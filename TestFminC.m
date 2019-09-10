
% This function tests the 'FMINCON' with Fredholm Reconstruction. %

function result = TestFminC(source_image,template,x0,lb,hb)

    im_o = im2double(imread(source_image));
    im_d = im2double(imread(template));
    cigma = 0.5;
    fun = @(X)FdnewValueF(X,im_o,im_d,cigma);
    
    A = [];
    b = [];
    Aeq = [];
    beq = [];
    nonlcon=[];
    options = optimoptions('fmincon','Display','iter','Algorithm','sqp');
    tic;
    result = fmincon(fun,x0,A,b,Aeq,beq,lb,hb,nonlcon,options);
    toc;
end
