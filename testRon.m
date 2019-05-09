

function result = testRon(a,imn1,imn2)
    im_o = im2double(imread(imn1));
    im_d = im2double(imread(imn2));
%    PSFinfo = PSFloc(im_d);
%    sigma = PSFRon(im_d,PSFinfo);
    sigma = 0.5;    
%     temp1 = dnewValueF(a,im_o,im_d,sigma);
    kemp2 = FdnewValueF(a,im_o,im_d,sigma);
    kemp3 = newValueF(a,im_o,im_d,sigma);
    
    result = kemp2 - kemp3;
end
