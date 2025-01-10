n = 4;
Tp = zeros(1, n);
distance = 100;
max_velocity = 50;
max_accel = 25;
max_jerk = 100;

x_peak = [distance, max_velocity, max_accel, max_jerk];

for p = n: -1: 1
    fprintf('currnt value of p = %d \n', p);
    product = 1;
    for i = 1: 1: n
        cummulator = 0;
        for j = 0: 1: i - 1
            cummulator = cummulator + (2^j * Tp(n+1-i+j));
        end
        cummulator = cummulator + Tp(n+1-i);
        product = product * cummulator; 
    end
    x0 = product * (X_n/2^n) ;   %here

    for q = 1: 1: (p-1)
        Xq_peak = 0;
        product = 1;
        for i = 1: 1: (n-q)
            cummulator = 0;
            for j = 0: 1: (i-1)
                cummulator = cummulator + (2^j * Tp(n+1-i+j)); 
            end
            cummulator = cummulator + Tp(n+1-i);
            product = product * cummulator; 
        end
        Xq_max = (X_n/2^(n-q)) * product;    %here
        
        %recalculate Tp
        if Xq_max > Xq_peak
            product = 1;
            for i = 1: 1: (n-q)
                cummulator = 0;
                for j = 0: 1: (i-1)
                    cummulator = cummulator + (2^j * Tp(n+1-i+j));
                end
                cummulator = cummulator + Tp(n+1-i);
                product = product * cummulator;
            end
            Xq_peak = product * (X_n/2^(n-q));
        end
    end
end


x_axis = 1:n;
plot(x_axis, Tp, '-o', 'LineWidth', 2, 'MarkerSize', 8);