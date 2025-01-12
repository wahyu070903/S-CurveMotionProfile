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
base_profile_time = [0
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
                    %8*Tp + 3*Tj + 2*Ta + Tv;
                    ];

disp(base_profile_time);
disp(half_base_profile);

stairs(base_profile_time, base_profile, 'LineWidth', 1);
