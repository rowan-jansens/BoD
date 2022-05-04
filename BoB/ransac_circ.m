function [circ_x, circ_y] = ransac_circ(x, y, known_radius)


n = 20;
sigma = 0.02;
% known_radius = 0.1329;
inlier_list = zeros(1,n);
center = zeros(n,2);
radius = zeros(1,n);

best_inliers = 0;
best_guess = [1 1];

% 
% p1_idx = randperm(length(x), n);
% p2_idx = randperm(length(x), n);
% p3_idx = randperm(length(x), n);

%loop thought random points
for i = 1:1000

%     %make data
%     x_pts = [x(p1_idx(i)) ; x(p2_idx(i)) ; x(p3_idx(i))];
%     y_pts = [y(p1_idx(i)) ; y(p2_idx(i)) ; y(p3_idx(i))];

    randpoints = datasample([x y], 3, "replace", false);

    x_pts = randpoints(:,1);
    y_pts = randpoints(:,2);

    %fit circle
    b_matrix = -x_pts.^2 - y_pts.^2;
    w_matrix = [x_pts y_pts ones(3,1)];
    circle_params = w_matrix \ b_matrix;
    radius(i) = sqrt(-circle_params(3) + circle_params(1)^2 / 4 + circle_params(2)^2 / 4);
    center(i,:) = [-circle_params(1)/2 -circle_params(2)/2];

    %categorize points as inlier or outliers
     inliers = 0;
     for j = 1:length(x)
        distance = sqrt((x(j) - center(i,1))^2 + (y(j) - center(i,2))^2);
        if distance < (known_radius + sigma) && distance > (known_radius - sigma)
             inliers = inliers + 1;
         end
     end

      if inliers > best_inliers
          best_inliers = inliers;
          best_guess = [-circle_params(1)/2 -circle_params(2)/2];
      end
end
% [~, idx] = max(inlier_list);
% circ_x = center(idx, 1);
% circ_y = center(idx, 2);



t = linspace(0, 2*pi, 100)';
 x1 = known_radius*cos(t) + best_guess(1);
 y1 = known_radius*sin(t) + best_guess(2);
%x2 = (radius(idx))*cos(t) + best_guess(1);
%y2 = (radius(idx))*sin(t) + best_guess(2);

%scatter(x_pts, y_pts, 30, "g", "filled")
plot(x1, y1, '-k', "Linewidth", 2);
%plot(x2, y2, '-r', "Linewidth", 2);
axis equal
title("RANSAC method")
xlim([-3 2])
ylim([-3 2])
end