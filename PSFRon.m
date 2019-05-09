

function result = PSFRon(imd,PSFi)
    PSF = imd(PSFi(1)-PSFi(2):+PSFi(1)+PSFi(2),PSFi(3)-PSFi(4):PSFi(3)+PSFi(4));
%     imshow(PSF,[]);
    PSFsize = size(PSF);
    sigma_x = zeros(PSFsize);
%     a_y = zeros(1,PSFsize(2));
    max_p = max(max(PSF));
    [PSFCx,PSFCy] = find(PSF==max_p);
    if (sum(size(PSFCx))~= 2)
        PSFC = [0 0];
        PSFC(1) = sum(PSFCx)/(sum(size(PSFCx))-1);
        PSFC(2) = sum(PSFCy)/(sum(size(PSFCy))-1);
    end
    
    for i = 1:PSFsize(1)
        for j = 1:PSFsize(2)
            if (PSF(i,j)~=0)
                sigma_x(i,j) = sqrt(-((i-PSFC(1))^2+(j-PSFC(2))^2)/(2*log(PSF(i,j))));
            end
        end
    end
    sigma_t = sum(sigma_x)/sum(sigma_x~=0);
    
    result = sigma_t;
end