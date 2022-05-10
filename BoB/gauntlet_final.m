%=============Guntlet Final===============
%=========================================
%start up ros for controlling the robot
pub = rospublisher('/raw_vel');
msg = rosmessage(pub);
% stop the robot's wheels in case they are running from before
msg.Data = [0, 0];
send(pub, msg);
pause(2);

%set inital postion and heading
position = [0;0];
heading = [1; 0];
%place the Neato in the starting location
placeNeato(position(1), position(2), heading(1), heading(2));
% wait a little bit for the robot to land after being positioned
pause(2);

%set the radius of the BoB
known_radius = 0.25;
figure(1)


%loop thoguht 10 itterations of path-finding
for i=1:10
%collect a clean lidar scan   
[x, y] = collect_scan();
%perform ransac search algorithm and find the center of the circle as well
%as the inliers and outliers (targets and obsacles)
[center, inliers, outliers] = lineandcircransac(x, y, known_radius);
%make potential feild from the data
[X, Y, potential] = make_potential_field(x, y, inliers, outliers);
%compute the gradient
[dx, dy] = gradient(potential, 0.1);


%evaluat the gradient at (0,0)
center_idx = 41;
ascent_vec = [-1*dx(center_idx,center_idx); -1*dy(center_idx,center_idx)]

%plot some stuff for visualizeing the Robot's next move
clf
hold on
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
xlabel('X (m)')
ylabel('Y (m)')
hold off

%this line returns the predicted path that the gradient ascent should
%follow based on the most recent lidar scan.
%path = predict_path(dx, dy, position, center, known_radius);
%plot(path(:,1), path(:,2), "k", 'linewidth', 2)


%feed the gradient vector to the ascent algorithm to update the position of
%the robot
gradient_ascent(ascent_vec, position, heading, pub, msg);

end