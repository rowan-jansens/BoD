%function res = gauntlet_final()
pub = rospublisher('/raw_vel');
msg = rosmessage(pub);
% stop the robot's wheels in case they are running from before
msg.Data = [0, 0];
send(pub, msg);
pause(2);

position = [0; 0];
heading = [1; 0];
% put the Neato in the starting location
placeNeato(position(1), position(2), heading(1), heading(2));
% wait a little bit for the robot to land after being positioned
pause(2);




known_radius = 0.25;
figure()

for i=1:10
    
[x, y] = collect_scan();
[center, inliers, outliers] = ransac_circ(x, y, known_radius);
[X, Y, potential] = make_potential_field(x, y, inliers, outliers);
[dx, dy] = gradient(potential, 0.1);
ascent_vec = [-1*dx(11,11); -1*dy(11,11)]
clf
hold on
th = 0:pi/50:2*pi;
xunit = known_radius * cos(th) + center(1);
yunit = known_radius * sin(th) + center(2);
h = plot(xunit, yunit, 'linewidth', 2);
scatter(inliers(:,1),inliers(:,2),10, "green", "filled")
scatter(outliers(:,1), outliers(:,2), 10, "red", "filled")
contour(X, Y, real(potential))
quiver(0, 0, ascent_vec(1), ascent_vec(2), .01)
axis([-3 3 -3 3])
hold off
gradient_ascent(ascent_vec, position, heading, pub, msg);


end













%end