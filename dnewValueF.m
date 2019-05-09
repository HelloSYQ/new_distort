

function result = dnewValueF(a_d,im_o,im_d,PSFinfo)

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
    K1 = a_d(1)*(X1.^2+Y1.^2)+a_d(2)*(X1.^4+Y1.^4+2*X1.^2+Y1.^2);
    pa = -1/(2*PSFinfo*PSFinfo);
    
    temp1 = zeros(image_size(1),image_size(1),image_size(1));
%    temp2 = zeros(image_size(1),image_size(1),image_size(1));
    for i = 1:image_size(1)
        S = i+K1;
        temp1(:,:,i) = exp(pa*((S-X).*(S-X)));
    end
    tic;
    for i = 1:image_size(1)
        for j = 1:image_size(1)
            image_kernel = temp1(:,:,i).*temp1(:,:,j);
            im_r(j,i) = sum(sum(im_o.*image_kernel));
        end
    end
    toc;
    im_r = im_r/(max(max(im_r)));
    result = im_d-im_r;
end