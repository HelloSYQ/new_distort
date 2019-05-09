

function result = newValueF(a_N,im_o,im_d,PSF_info)

    image_size = size(im_o);
    im_r = zeros(image_size);
    [X,Y] = meshgrid(1:image_size(1),1:image_size(2));
    if mod(image_size(1),2) == 1
        im_c = (image_size(1)+1)/2;
    else
        im_c = image_size(1)/2;
    end
    
    X1 = X - im_c;
    Y1 = Y - im_c;

    K2 = a_N(1)*(X1.^2+Y1.^2)+a_N(2)*(X1.^4+2*X1.^2.*Y1.^2+Y1.^4);
    for i = 1:image_size(1)
        for j = 1:image_size(2)
            S = i+K2.*(X1);
            T = j+K2.*(Y1);
            image_kernel = exp(-1/(2*PSF_info*PSF_info)*((S-X).^2+(T-Y).^2));
            im_r(j,i) = sum(sum(im_o.*image_kernel));
        end
    end
    im_r = im_r/(max(max(im_r)));
%    figure;
%    imshow(im_r);
%    result = sum(sum((im_r-im_d).^2));
    result = im_r;
end
