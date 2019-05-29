% This jiaoben is designed to run a auto check between the reconstructed image %
% and the distortion template.                                                 %

p1 = [-18,-23];
p2 = [181,150];
r1 = FExampleP('pointsr.png','fredrec_noi.png',p1);
r2 = ext_pointDis('pointsr.png','pointrec_noi.png',p2);

sor = im2double(imread('demo_noise1.png'));

ImageFormatM(r1,15,20,jet,'x(pixel)','y(pixel)','',[0,1],'fredrec_noi_f.png');
ImageFormatM(r2,15,20,jet,'x(pixel)','y(pixel)','',[0,1],'pointrec_noi_f.png');
ImageFormatM(r1-sor,15,20,jet,'x(pixel)','y(pixel)','',[-1,1],'fredrec_noi_f_err.png');
ImageFormatM(r2-sor,15,20,jet,'x(pixel)','y(pixel)','',[-1,1],'pointrec_noi_f_err.png');

