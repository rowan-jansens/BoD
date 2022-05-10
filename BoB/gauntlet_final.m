%function res = gauntlet_final()
pub = rospublisher('/raw_vel');
msg = rosmessage(pub);
% stop the robot's wheels in case they are running from before
msg.Data = [0, 0];
send(pub, msg);
pause(2);

%position = [0.6; -1.5];
position = [0;0];
heading = [1; 0];
% put the Neato in the starting location
placeNeato(position(1), position(2), heading(1), heading(2));
% wait a little bit for the robot to land after being positioned
pause(2);




known_radius = 0.25;
figure(1)



for i=1:1
    

[x, y] = collect_scan();
[center, inliers, outliers] = lineandcircransac(x, y, known_radius);
[X, Y, potential] = make_potential_field(x, y, inliers, outliers);
[dx, dy] = gradient(potential, 0.1);


path = predict_path(dx, dy, position, center, known_radius);


center_idx = 41;
ascent_vec = [-1*dx(center_idx,center_idx); -1*dy(center_idx,center_idx)]
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



%title('Gauntlet Gradient Field from Iinitial LIDAR Scan')
xlabel('X (m)')
ylabel('Y (m)')
%legend('Best Fit Circle', 'Target', 'Obstacles','\nablaF','Neato')


plot(path(:,1), path(:,2), "k", 'linewidth', 2)
gradient_ascent(ascent_vec, position, heading, pub, msg);
norm(center)



hold off
end













%end