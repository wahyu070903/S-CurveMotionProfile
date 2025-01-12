classdef ConstantPeriod
    properties
        start_pos;
        end_pos;
        max_vel;
        max_acc;
        max_jerk;
    end
    methods
        %constructor
        function obj = ConstantPeriod(start_pos, end_pos, max_vel, max_acc, max_jerk)
            obj.start_pos = start_pos;
            obj.end_pos = end_pos;
            obj.max_vel = max_vel;
            obj.max_acc = max_acc;
            obj.max_jerk = max_jerk;
        end

        function Tp = computePeriod(obj)
            Tp = 0;
            n = 4;  %3rd dimension (n-1);
            max_bound = [obj.end_pos, obj.max_vel, obj.max_acc, obj.max_jerk];
            for p = n:-1:1
                coff = [obj.max_jerk, obj.max_acc, obj.max_vel, -obj.end_pos];
                solv = roots(coff);
                positive_real_roots = solv(real(solv) > 0 & imag(solv) == 0);
                Tp = positive_real_roots;
            
                for q = 1: 1: (p-1)
                    product = 1;
                    for i = 1: 1: (n-q)
                        cummulator = 0;
                        for j = 0: 1: (i-1)
                            cummulator = cummulator + (2^j * Tp); 
                        end
                        cummulator = cummulator + Tp;
                        product = product * cummulator; 
                    end
                    Xq_max = (obj.max_jerk/2^(n-q)) * product;    %here
                    if(Xq_max > max_bound(q))
                        %fprintf("bound exceed\n");
                        coff = zeros(1,n);
                        if(q == 1)
                            %fprintf("cond1\n");
                            coff = [obj.max_jerk, obj.max_acc, obj.max_vel, -obj.end_pos - obj.max_vel];
                        end
                        if(q ==2)
                            %fprintf("cond2\n");
                            coff = [obj.max_jerk, obj.max_acc, obj.max_vel, -obj.end_pos - obj.max_acc];
                        end
                        if(q == 3)
                            %fprintf("cond3\n");
                            coff = [obj.max_jerk, obj.max_acc, obj.max_vel, -obj.end_pos - obj.max_jerk];
                        end
                        solv = roots(coff);
                        positive_real_roots = solv(real(solv) > 0 & imag(solv) == 0);
                        Tp = positive_real_roots;
                        %disp(Tp);
                    end
                end
            end
            %fprintf("final value : \n");
            %disp(Tp);
        end
    end
end






