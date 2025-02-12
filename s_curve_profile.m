% System limits
max_velocity = 10.0;  % r/s
max_acceleration = 2.0;  % r/s^2
max_jerk = 1.0;  % r/s^3

% Time parameters (to be tuned based on motion requirements)
t_total = 10;  % Total time for the motion (seconds)

t_ramp = sqrt(max_acceleration / max_jerk);  % Time for acceleration ramp
t_damp = sqrt(max_acceleration / max_jerk);

t_flat = t_total - 2 * (t_ramp + t_damp);  % Constant velocity duration

t = linspace(0, t_total, 1000);  % Time vector

% Jerk profile (trigonometric example)
jerk = zeros(size(t));
for i = 1:length(t)
    if t(i) <= t_ramp
        jerk(i) = max_jerk * sin(pi * t(i) / t_ramp);
    elseif t(i) <= (t_total - t_ramp)
        jerk(i) = 0;  % Constant velocity
    else
        jerk(i) = -max_jerk * sin(pi * (t_total - t(i)) / t_ramp);
    end
end

% Integrate jerk to get acceleration, velocity, and position
acceleration = cumtrapz(t, jerk);
velocity = cumtrapz(t, acceleration);
position = cumtrapz(t, velocity);

figure;
subplot(3,1,1);
plot(t, acceleration, 'r');
title('Acceleration Profile');
xlabel('Time (s)');
ylabel('Acceleration (m/s^2)');

subplot(3,1,2);
plot(t, velocity, 'g');
title('Velocity Profile');
xlabel('Time (s)');
ylabel('Velocity (m/s)');

subplot(3,1,3);
plot(t, position, 'b');
title('Position Profile');
xlabel('Time (s)');
ylabel('Position (m)');
