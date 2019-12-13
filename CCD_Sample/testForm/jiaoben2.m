
    k = 1:401;
    Q = zeros(1,401);
    f = @(x) exp(-((x-200).^2)/400);
    for i = 1:401;
        Q(i) = integral(f,i-1/2,i+1/2);
    end;
    rect = zeros(1,401);
    rect(1) = 1;
    rect(2) = 1;
    %H = fft(rect);

    new_h = 0.5*onedimshift_function(-0.5,rect);
    new_H = fft(new_h);
    
    y = f_1(k);
    %F1 = fft(y);

    F2 = fft(Q);
    recF = ifftshift(fftshift(F2)./fftshift(new_H));
    recf = ifft(recF);