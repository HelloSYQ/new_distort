

G = zeros(401,401);
for i = 1:401
    for j = 1:401
        g = @(x) sin(pi*(x-i))./(pi*(x-i));
        G(i,j) = integral(g,j-0.5,j+0.5);
    end
end