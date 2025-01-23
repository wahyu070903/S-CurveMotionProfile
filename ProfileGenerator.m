start_pos = 0;
end_pos = 100;  %radian 
max_vel = 4.0;   %rps
max_acc = 2.4;
max_jerk = 2.8;

period = ConstantPeriod(start_pos, end_pos, max_vel, max_acc, max_jerk);
Tp = period.computePeriod();

Tj = max_acc/max_jerk;
Ta = max_vel/max_acc - max_acc/max_jerk;
Tv = (end_pos-start_pos)/max_vel - max_vel/max_acc - max_acc/max_jerk;

base_profile = [1,0,-1,0,-1,0,1,0,-1,0,1,0,1,0,-1];
base_profile_time = [
                    Tp;
                    Tp + Tj;
                    2*Tp + Tj;
                    2*Tp + Tj + Ta;
                    3*Tp + Tj + Ta;
                    3*Tp + 2*Tj + Ta;
                    4*Tp + 2*Tj + Ta;
                    4*Tp + 2*Tj + Ta + Tv;
                    5*Tp + 2*Tj + Ta + Tv;
                    5*Tp + 3*Tj + Ta + Tv;
                    6*Tp + 3*Tj + Ta + Tv;
                    6*Tp + 3*Tj + 2*Ta + Tv;
                    7*Tp + 3*Tj + 2*Ta + Tv;
                    7*Tp + 4*Tj + 2*Ta + Tv;
                    8*Tp + 3*Tj + 2*Ta + Tv;
                    ];

t_base = linspace(0,base_profile_time(15), 1000);
base = zeros(length(t_base));
counter1 = 1;
for i = 1:length(t_base)
    if(t_base(i) <= base_profile_time(counter1))
        base(i) = base_profile(counter1);
    elseif(t_base(i) > base_profile_time(counter1))
        counter1 = counter1 + 1;
    end
end

t_jerk = linspace(0,base_profile_time(15), 1000);
jerk = zeros(1,(length(t_jerk)/2));
counter2 = 1;
for i=1:1:length(jerk)
    if(t_jerk(i) <= base_profile_time(1))
        inner = (((2*pi)/Tj)*t_jerk(i)) + (pi/2);
        jerk(i) = (max_jerk/2)*(1-sin(inner));
    elseif(t_jerk(i) <= base_profile_time(2))
        jerk(i) = max_jerk;
    elseif(t_jerk(i) <= base_profile_time(3))
        inner = (((2*pi)/Tj)*(t_jerk(i) - base_profile_time(2))) + (pi/2);
        jerk(i) = (max_jerk/2)*(1-sin(inner));
    elseif(t_jerk(i) <= base_profile_time(4))
        jerk(i) = 0;
    elseif(t_jerk(i) <= base_profile_time(5))
        inner = (((2*pi)/Tj)*(t_jerk(i) - base_profile_time(4))) + (pi/2);
        jerk(i) = -(max_jerk/2)*(1-sin(inner));
    elseif(t_jerk(i) <= base_profile_time(6))
        jerk(i) = -max_jerk;
    elseif(t_jerk(i) <= base_profile_time(7))
        inner = (((2*pi)/Tj)*(t_jerk(i) - base_profile_time(6))) + (pi/2);
        jerk(i) = -(max_jerk/2)*(1-sin(inner));
    else
        jerk(i) = 0;
    end
end

jerk = [jerk, fliplr(jerk(1:end))];

figure;
subplot(3,1,1);
plot(t_base, base, 'b');
title('Base Profile');
xlabel('Time (s)');
ylabel('Base (pos/neg)');
ylim([-1.5, 1.5]);


subplot(3,1,2);
plot(t_jerk, jerk, 'g');
title('Jerk Profile');
xlabel('Time (s)');
ylabel('Base (jerk)');





