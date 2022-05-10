function [best_center, best_inlier_list, best_outlier_list] = ransac_circ(x, y, known_radius)
%sigma is the tolerance for what is and is not considered an inlier
sigma = 0.02;

%initializes the number of inliers and the center of the best fit
best_inliers = 0;
best_center = [0 0];

%initializes the attributes of the current random circle
inlier_list = [];
outlier_list = [];

%initializes the inliers and outliers of the best fit
best_inlier_list = [];
best_outlier_list = [];
%loop thought random points
for i = 1:300
    %select 2 random point indices
    p1 = randi(length(x));
    p2 = randi(length(x));
    %check to make sure they are different, else pick a new one
    while(p2 == p1)
        p2 = randi(length(x));
    end
    %pick a third random point 
    p3 = randi(length(x));
    %make sure the third point is different, else pick a new one
    while(p3 == p1 || p3 == p2)
        p3 = randi(length(x));
    end
    
    %create an array of x values and y values of the points from the
    %indices selected for easier use
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
         %calculate the distance between a point and the center of the
         %random circle
        distance = sqrt((x(j) - center(i,1))^2 + (y(j) - center(i,2))^2);
        %if the point is within sigma of the circle, add it to the inliers,
        %else add it to the outliers
        if distance < (known_radius + sigma) && distance > (known_radius - sigma)
             inliers = inliers + 1;
             inlier_list(end+1,:) = [x(j) y(j)];
        else
            outlier_list(end+1,:) = [x(j) y(j)];
        end
        
     end
      %if the number of inliers of the current random circle is greater
      %than the number on the current best circle, replace the current best
      %circle with the current random circle
      if inliers > best_inliers
          best_inliers = inliers;
          best_center = [-circle_params(1)/2 -circle_params(2)/2];
          best_inlier_list = inlier_list;
          best_outlier_list = outlier_list;
      end
    end
end