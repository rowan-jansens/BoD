%load my_data.csv
clf
load potential.mat;
load outliers.mat;
load inliers.mat;
load center.mat;
load X.mat;
load Y.mat;
points = [inliers; outliers];
known_radius = 0.25;
data = readtable('my_data.csv');
rt = encoder_witchcraft(data, 105, 800);
hold on
plot(rt(:, 1), rt(:,2), 'k--', 'linewidth', 2)
plot(path(:,1), path(:,2), 'linewidth', 2)
xlabel('X Position (m)')
ylabel('Y Position (m)')
title('Theoretical vs Measured Neato Path')
grid on

th = 0:pi/50:2*pi;
xunit = known_radius * cos(th) + center(1);
yunit = known_radius * sin(th) + center(2);
h = plot(xunit, yunit, 'linewidth', 2);
scatter(inliers(:,1),inliers(:,2),10, "green", "filled")
scatter(outliers(:,1), outliers(:,2), 10, "red", "filled")
contour(X, Y, real(potential),30)
%quiver(X, Y, dx, dy, 2, "color", [.3 0.7 .3])

scatter(0,0,100, 'sb',  "filled")
%quiver(0, 0, ascent_vec(1), ascent_vec(2), .01)

axis([-1.5 3.5 -3 1])
legend('Theoretical Path', 'Measured Path', '', '', '', '', 'Neato')
hold off