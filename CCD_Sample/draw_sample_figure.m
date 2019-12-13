
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