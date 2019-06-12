% mx = 10; % Maximum intensity of the true image
% mn = 0.9; % Minimum intensity of the true image
function [y,img]= poisson_count(x,mn,mx)
if nargin == 3
    x = x - min( x(:) );
    x = x ./ max(x(:));%先把图片中的像素归一化
    img = mn + x * (mx-mn);
else
    img = x;
end
y = poissrnd(img);
