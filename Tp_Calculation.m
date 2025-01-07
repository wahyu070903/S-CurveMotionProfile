n = 4;
Tp = zeros(1, n);

for p = n: -1: 1
    fprintf('currnt value of p = %d \n', p);
    product = 1;
    for i = 1: 1: n
        cummulator = 0;
        for j = 0: 1: q - 1
            cummulator = cummulator + (2^j * Tp(n+1-i+j));
        end
        cummulator = cummulator + Tp(n+1-i);
        product = product * cummulator; 
    end
    x0 = product * (x5/2^n) ;
end