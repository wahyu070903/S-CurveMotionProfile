start_pos = 0;
end_pos = 100;  %radian 
max_vel = 4.0;   %rps
max_acc = 2.4;
max_jerk = 2.8;

Tp = 0;
n = 4;  %3rd dimension (n-1);
max_bound = [end_pos, max_vel, max_acc,max_jerk];
for p = n:-1:1
    coff = [max_jerk, max_acc, max_vel, -end_pos];
    solv = roots(coff);
    positive_real_roots = solv(real(solv) > 0 & imag(solv) == 0);
    Tp = positive_real_roots;

    for q = 1: 1: (p-1)
        Xq_peak = 0;
        product = 1;
        for i = 1: 1: (n-q)
            cummulator = 0;
            for j = 0: 1: (i-1)
                cummulator = cummulator + (2^j * Tp); 
            end
            cummulator = cummulator + Tp;
            product = product * cummulator; 
        end
        Xq_max = (max_jerk/2^(n-q)) * product;    %here
        if(Xq_max > max_bound(q))
            fprintf("bound exceed\n");
            coff = zeros(1,n);
            if(q == 1)
                fprintf("cond1\n");
                coff = [max_jerk, max_acc, max_vel, -end_pos - max_vel];
            end
            if(q ==2)
                fprintf("cond2\n");
                coff = [max_jerk, max_acc, max_vel, -end_pos - max_acc];
            end
            if(q == 3)
                fprintf("cond3\n");
                coff = [max_jerk, max_acc, max_vel, -end_pos - max_jerk];
            end
            solv = roots(coff);
            positive_real_roots = solv(real(solv) > 0 & imag(solv) == 0);
            Tp = positive_real_roots;
            disp(Tp);
        end
    end
end

fprintf("final value : \n");
disp(Tp);

