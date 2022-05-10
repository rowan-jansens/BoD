%load my_data.csv
load potential.mat;
load outliers.mat;
load inliers.mat;
load center.mat;
known_radius = 0.1329;
data = readtable('my_data.csv');
rt = encoder_witchcraft(data, 105, 800);
hold on
plot(rt(:, 1), rt(:,2), 'k--')
plot(path(:,1), path(:,2))
xlabel('X Position (m)')
ylabel('Y Position (m)')
title('Theoretical vs Measured Neato Path')
grid on
legend('1', '2', '3', '4', '5','6','7')
th = 0:pi/50:2*pi;
xunit = known_radius * cos(th) + center(1);
yunit = known_radius * sin(th) + center(2);
h = plot(xunit, yunit, 'linewidth', 2);
scatter(inliers(:,1),inliers(:,2),10, "green", "filled")
scatter(outliers(:,1), outliers(:,2), 10, "red", "filled")
contour(X, Y, real(potential),30)
%quiver(X, Y, dx, dy, 2, "color", [.3 0.7 .3])

scatter(0,0,100, 'sb',  "filled")
quiver(0, 0, ascent_vec(1), ascent_vec(2), .01)

axis([-2 2 -2 2])
hold off