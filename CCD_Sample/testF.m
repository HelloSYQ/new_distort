
function result = testF(test_length,shift_length)
    k = 1:test_length;
    Q = zeros(1,test_length);
    mid_length = (test_length-1)/2;
    f = @(x) exp(-((x-mid_length).^2)/100);
    for i = 1:test_length;
        Q(i) = integral(f,i-1/2,i+1/2);
    end;
    rect = zeros(1,test_length);
    rect(1) = 1;
    rect(2) = 1;
    %H = fft(rect);

    new_h = 0.5*onedimshift_function(shift_length,rect);
    new_H = fft(new_h);
    %figure;
    %subplot(2,1,1);
    %plot(k,abs(new_h));
    %subplot(2,1,2);
    figure;
    plot(k,fftshift(abs(new_H)),'LineWidth',2);
    grid on;
    axis on;
    title('Frequency Spetrum of the Rectangle Window');
    set(gca,'FontSize',15);
    print(gcf,'-dpng','window.png','-r300');
    
    y = f_1(k);
    %F1 = fft(y);

    F2 = fft(Q);
    recF = ifftshift(fftshift(F2)./fftshift(new_H));
    %recF(201) = 0;
    recf = ifft(recF);
    
    figure;
    set(gcf,'units','normalized','position',[0.1 0.1 0.55 0.8]);
    set(gca,'position',[0.05 0.13 0.9 0.8]);
    subplot(211);
    plot(k,y,'LineWidth',2);
    legend('Gaussian Source');
    set(gca,'FontSize',12);
    set(gca,'XGrid','on');
    set(gca,'YGrid','on');
    subplot(212);
    plot(k,Q,'-r','LineWidth',2);
    legend('Gaussian Source Covoluted with a Rectangle Window');
    set(gca,'FontSize',15);
    set(gca,'XGrid','on');
    set(gca,'YGrid','on');
    print(gcf,'-dpng','gauss.png','-r300');
    
    figure;
    set(gcf,'units','normalized','position',[0.1 0.1 0.55 0.8]);
    set(gca,'position',[0.05 0.13 0.9 0.8]);
    plot(k,abs(recf)-y,'-r','LineWidth',2);
    
    grid on;
    hold on;
    axis on;
    plot(k,abs(recf)-Q,'-k','LineWidth',1);

    plot(k,y-Q,'LineWidth',1);
    set(gca,'FontSize',12);
    legend('Error between Reconstructed and Source','Error between Reconstructed and Sample','Error between Sample and Source');
    title('Reconstructed Signal from Integral Sampled Signal');
    print(gcf,'-dpng','Sim.png','-r300');
    result = recf;
end