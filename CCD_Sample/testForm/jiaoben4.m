


    G = zeros(20,20);
    for i = 1:20
        for j = 1:20
            g = @(x) sin(pi*(x-i))./(pi*(x-i));
            G(i,j) = integral(g,j-0.5,j+0.5);
        end
    end

    k = 1:20;
    Q = zeros(1,20);
    f = @(x) exp(-((x-10).^2)/9);
    for i = 1:20;
        Q(i) = integral(f,i-1/2,i+1/2);
    end;
    rect = zeros(1,20);
    rect(1) = 1;
    rect(2) = 1;
    %H = fft(rect);

    new_h = 0.5*onedimshift_function(-0.5,rect);
    new_H = fft(new_h);
    
    y = exp(-((k-10).^2)/9);
    %F1 = fft(y);

    F2 = fft(Q);
    recF = ifftshift(fftshift(F2)./fftshift(new_H));
    recf = ifft(recF);