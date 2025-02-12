start_pos = 0;
end_pos = 100;  %radian 
max_vel = 8.0;   %rps
max_acc = 2.4;
max_jerk = 1.8;

period = ConstantPeriod(start_pos, end_pos, max_vel, max_acc, max_jerk);
Tp = period.computePeriod();

Tj = max_acc/max_jerk;
Ta = max_vel/max_acc - max_acc/max_jerk;
Tv = (end_pos-start_pos)/max_vel - max_vel/max_acc - max_acc/max_jerk;

base_profile = [1,0,-1,0,-1,0,1,0,-1,0,1,0,1,0,-1];

time_profile = [
                    Tj;
                    Tj + Ta;
                    2*Tj + Ta;
                    2*Tj + Ta + Tv;
                    3*Tj + Ta + Tv;
                    3*Tj + 2*Ta + Tv;
                    4*Tj + 2*Ta + Tv;
               ];
t_jerk = linspace(0,time_profile(7),1000);
jerk = zeros(1, length(t_jerk)/2);

for i=1:1:(length(t_jerk)/2)
    if(t_jerk(i) <= time_profile(1))
        jerk(i) = max_jerk;
    elseif(t_jerk(i) <= time_profile(2))
        jerk(i) = 0;
    elseif(t_jerk(i) <= time_profile(3))
        jerk(i) = -max_jerk;
    else
        jerk(i) = 0;
    end
end
jerk = [jerk, fliplr(jerk(1:end))];

t_accel = linspace(0,time_profile(7),1000);
accel = zeros(1, length(t_accel)/2);

for i=1:1:(length(t_accel)/2)
    if(t_accel(i) <= time_profile(1))
        accel(i) = max_jerk * t_accel(i);
    elseif(t_accel(i) <= time_profile(2))
        accel(i) = max_acc;
    elseif(t_accel(i) <= time_profile(3))
        accel(i) = max_acc - max_jerk * (t_accel(i)-time_profile(2));
    else
        accel(i) = 0;
    end
end
accel = [accel, -fliplr(accel(1:end))];

t_vel = linspace(0,time_profile(7),1000);
vel = zeros(1, length(t_vel)/2);

for i=1:1:(length(t_vel)/2)
    if(t_vel(i) <= time_profile(1))
        vel(i) = 0.5 * max_jerk * (t_vel(i)^2);
    elseif(t_accel(i) <= time_profile(2))
        vel(i) = (0.5 * max_acc * Tj) + (max_acc * (t_accel(i) - time_profile(1)));
    elseif(t_accel(i) <= time_profile(3))
        vel(i) = max_acc*(Tj/2 + Ta) + (max_acc * (t_accel(i) - time_profile(2))) - (1/2*max_jerk*(t_accel(i) - time_profile(2))^2);
    else
        vel(i) = max_vel;
    end
end
vel = [vel, fliplr(vel(1:end))];

figure;
subplot(3,1,1);
plot(t_jerk, jerk, 'b');
title('Jerk Profile');
xlabel('Time (s)');
ylabel('Jerk');
xlim([0, time_profile(7)]);

subplot(3,1,2);
plot(t_accel, accel, 'g');
title('Accel Profile');
xlabel('Time (s)');
ylabel('Accel (m/s2)');
xlim([0, time_profile(7)]);

subplot(3,1,3);
plot(t_vel, vel, 'r');
title('Vel Profile');
xlabel('Time (s)');
ylabel('Vel (m/s)');
xlim([0, time_profile(7)]);



