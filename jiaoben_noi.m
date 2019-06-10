% This jiaoben is designed to run a auto check between the reconstructed image %
% and the distortion template.                                                 %

p1 = [-18,-23]*10^-12;
p2 = [1.83e-7,1.497e-11];
sr = im2double(imread('pointsr.png'));
r1 = FExampleP('pointsr.png','fredrec_noi.png',p1,'false',0.0001);
r2 = ext_pointDis(sr,p2);

sor = im2double(imread('demo_noise1.png'));

r1_cut = r1(1:160,1:160);
r2_cut = r2(1:160,1:160);
sor_cut = sor(1:160,1:160);

ImageFormatM(r1,15,20,jet,'x(pixel)','y(pixel)','',[0,1],'fredrec_noi_f.png');
ImageFormatM(r2,15,20,jet,'x(pixel)','y(pixel)','',[0,1],'pointrec_noi_f.png');
ImageFormatM(r1-sor,15,20,jet,'x(pixel)','y(pixel)','',[-1,1],'fredrec_noi_f_err.png');
ImageFormatM(r2-sor,15,20,jet,'x(pixel)','y(pixel)','',[-1,1],'pointrec_noi_f_err.png');
ImageFormatM(r1_cut,15,20,jet,'x(pixel)','y(pixel)','',[0,1],'fredrec_noi_cut.png');
ImageFormatM(r2_cut,15,20,jet,'x(pixel)','y(pixel)','',[0,1],'pointrec_noi_cut.png');
ImageFormatM(r1_cut-sor_cut,15,20,jet,'x(pixel)','y(pixel)','',[0,1],'fredrec_noi_err_cut.png');
ImageFormatM(r2_cut-sor_cut,15,20,jet,'x(pixel)','y(pixel)','',[0,1],'pointrec_noi_err_cut.png');
