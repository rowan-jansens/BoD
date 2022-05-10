function [best_center, best_inlier_list, best_outlier_list] = ransac_circ(x, y, known_radius)



sigma = 0.02;
% known_radius = 0.1329;

best_inliers = 0;
best_center = [0 0];

inlier_list = [];
outlier_list = [];
best_inlier_list = [];
best_outlier_list = [];
%loop thought random points
for i = 1:300

%     %make data
%     x_pts = [x(p1_idx(i)) ; x(p2_idx(i)) ; x(p3_idx(i))];
%     y_pts = [y(p1_idx(i)) ; y(p2_idx(i)) ; y(p3_idx(i))];

    %randpoints = datasample0([x y], 3, "replace", false);
    p1 = randi(length(x));
    p2 = randi(length(x));
    while(p2 == p1)
        p2 = randi(length(x));
    end
    p3 = randi(length(x));
    while(p3 == p1 || p3 == p2)
        p3 = randi(length(x));
    end




%     x_pts = randpoints(:,1);
%     y_pts = randpoints(:,2);
x_pts = [x(p1) ; x(p2) ; x(p3)];
y_pts = [y(p1) ; y(p2) ;  y(p3)];

    %fit circle
    b_matrix = -x_pts.^2 - y_pts.^2;
    w_matrix = [x_pts y_pts ones(3,1)];
    circle_params = w_matrix \ b_matrix;
    radius(i) = sqrt(-circle_params(3) + circle_params(1)^2 / 4 + circle_params(2)^2 / 4);
    center(i,:) = [-circle_params(1)/2 -circle_params(2)/2];

    %categorize points as inlier or outliers
     inliers = 0;
     inlier_list = [];
     outlier_list = [];
     for j = 1:length(x)
        distance = sqrt((x(j) - center(i,1))^2 + (y(j) - center(i,2))^2);
        if distance < (known_radius + sigma) && distance > (known_radius - sigma)
             inliers = inliers + 1;
             inlier_list(end+1,:) = [x(j) y(j)];
        else
            outlier_list(end+1,:) = [x(j) y(j)];
        end
        
     end

      if inliers > best_inliers
          best_inliers = inliers;
          best_center = [-circle_params(1)/2 -circle_params(2)/2];
          best_inlier_list = inlier_list;
          best_outlier_list = outlier_list;
      end
end


%t = linspace(0, 2*pi, 100)';
 %x1 = known_radius*cos(t) + best_center(1);
 %y1 = known_radius*sin(t) + best_center(2);
%x2 = (radius(idx))*cos(t) + best_guess(1);
%y2 = (radius(idx))*sin(t) + best_guess(2);

%scatter(x_pts, y_pts, 30, "g", "filled")
%plot(x1, y1, '-k', "Linewidth", 2);
%plot(x2, y2, '-r', "Linewidth", 2);
% axis equal
%title("RANSAC method")
%xlim([-3 2])
%ylim([-3 2])
end