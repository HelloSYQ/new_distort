
<<<<<<< HEAD
new_x = 1:0.25:21;
new_z = exp(-((new_x-11).^2)/4);
new_zint = OneDScale(zint,4);
new_zinv = OneDScale(zinv,4);

figure;
set(gcf,'units','normalized','position',[0.1 0.1 0.6 0.8]);
set(gca,'position',[0.02 0.1 1 0.8]);

subplot(321);
bar(z);
title('Ideal Gaussian Signal')
grid on;
set(gca,'FontSize',14);
subplot(323);
bar(zint);
title('CCD Sampled Gaussian Signal')
grid on;
set(gca,'FontSize',14);
subplot(325);
bar(zinv);
title('Recovered Gaussian Signal from Sample')
grid on;
set(gca,'FontSize',14);
subplot(322);
hold on;
plot(new_x,new_z,'r');
plot(new_x,new_zint,'b');
plot(new_x,new_zinv);
subplot(324);
bar(zint-z);
title('Error between Ideal and Sampled Signals')
grid on;
set(gca,'FontSize',14);
subplot(326);
bar(zinv'-z);
title('Error between Ideal and Recovered Signals')
grid on;
set(gca,'FontSize',14);
=======
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function draws the figures of 1-D sampling effect. %
% The default frequency domain multiplier is 4.           %
% Input:                                                  %
% test_length: integer, length of the gaussian sequence.  %
% sigma      : double, sigma of the gaussian profile.     %
% Output:                                                 %
% illstrative figures explaining the 1-D sampling effect. %
% Date: 2019-12-29 ===== Author: Hellosyq                 %
% Version 1.0                                             %
%                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function result = draw_sample_figure(test_length,sigma)
    x = 1:test_length;
    marker = (test_length+1)/2;
    z = exp(-(x-marker).^2/sigma^2);
    zint = sampling_sim_calc(test_length,sigma);
    G = sampling_mat_calc(test_length);
    Ginv = G^(-1);
    zinv = Ginv*zint';

    new_x = 1:0.25:test_length;
    new_z = exp(-((new_x-marker).^2)/sigma^2);
    new_zint = OneDScale(zint,4);
    new_zinv = OneDScale(zinv,4);
    new_err = OneDScale(zinv-z',4);
    new_zint = new_zint(1:(test_length-1)*4+1);
    new_zinv = new_zinv(1:(test_length-1)*4+1);
    new_err = new_err(1:(test_length-1)*4+1);

    figure;
    set(gcf,'units','normalized','position',[0.1 0.1 0.6 0.8]);
    set(gca,'position',[0.02 0.1 1 0.8]);

    subplot(321);
    bar(z);
    title('Ideal Gaussian Signal')
    grid on;
    set(gca,'FontSize',14);

    subplot(323);
    bar(zint);
    title('CCD Sampled Gaussian Signal')
    grid on;
    set(gca,'FontSize',14);

    subplot(325);
    bar(zinv);
    title('Recovered Gaussian Signal from Sample')
    grid on;
    set(gca,'FontSize',14);

    subplot(322);
    hold on;
    plot(new_x,new_z,'k','LineWidth',2);
    plot(new_x,new_zint,'b','LineWidth',2);
    plot(new_x,new_zinv,'r','LineWidth',2);
    grid on;
    title('Expanded Gaussian Curves in Frequency Domian')
    set(gca,'FontSize',14);

    subplot(324);
    bar(zint-z);
    hold on;
    plot(new_x,new_zint'-new_z,'r','LineWidth',2);
    title('Error between Ideal and Sampled Signals');
    grid on;
    set(gca,'FontSize',14);

    subplot(326);
    bar(zinv'-z);
    hold on;
    plot(new_x,new_err,'r','LineWidth',2);
    plot(new_x,new_zinv'-new_z,'r','LineWidth',2)
    title('Error between Ideal and Recovered Signals')
    grid on;
    set(gca,'FontSize',14);

end
>>>>>>> d3eb079a492b11dfa8e608f3959ccd5c9a069639
