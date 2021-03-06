function [best_center, best_inlier_list, best_outlier_list] = lineandcircransac(x, y, known_radius)

line_sigma = 0.001; %how far away from a random line a point can be before it is considered an outlier
no_circ = true; %while loop variable, whether or not a good circle has been found
to_add_later = []; %array of the points discarded from lines found before the best circle is discovered

%loops until circle is found
while no_circ
    
    %finds a circle using RANSAC
    [circ_center, best_circ_inliers, best_circ_outliers] = ransac_circ(x,y,known_radius);

    %initializing the matricies of the best fit attributes
    best_line_inliers = [];
    best_line_outliers = [];
    best_line = [];
    
    %the following loop performs RANSAC to find a line 
    for j = 1:300
        
        %selects 2 random indicies from all the x values
        p1 = randi(length(x));
        p2 = randi(length(x));
        %makes sure that the 2 indicies aren't the same, if they are it
        %chooses a new one
        while(p2 == p1)
            p2 = randi(length(x));
        end
        
        %converts the indicies into the points the represent for easier
        %math
        p1 = [x(p1) y(p1)];
        p2 = [x(p2) y(p2)];
        
        %finds the vector between the 2 random points
        v =(p2-p1)';
        %computes the normal vector to vector between the points
        n = [-v(2); v(1)];
        %calculates the unit vector of the normal vector
        nhat = n/norm(n);
        
        %initializes the arrays of the inlier and outlier points for eah
        %random line
        line_inliers = [];
        line_outliers = [];
        
        %the following loop checks each point to see if it is an inlier or
        %an outlier, then stores them as such
        for k = 1:length(x)
            
            %calculates the vector between a point and one of the points
            %used to generate the random line
            diff = [x(k, :) , y(k, :)] - p1;
            %projects the vector on to the normal unit vector to the line,
            %effectively finding the perpendicular distance between the
            %random point and the line
            perp_distance = dot(diff,nhat);
            
            %if the point is close enough to the line, saves it as an
            %inlier, otherwise saves it as a outlier
            if abs(perp_distance) < line_sigma
                line_inliers = [line_inliers ; [x(k,:), y(k,:)]];
            else
                line_outliers = [line_outliers ; [x(k, :), y(k, :)]];
            end
        end
        
        %if the random line has more inliers than any previous random line,
        %it is saved
            if length(line_inliers) > length(best_line_inliers)
                best_line_inliers = line_inliers;
                best_line_outliers = line_outliers;
                best_line = [p1;p2];
            end
        
    %checking if circle better than line
    end
    if length(best_line_inliers) > length(best_circ_inliers)
        %if the line is better, throw out all the line's inliers and rerun
        %the whole loop
        x = best_line_outliers(:, 1);
        y = best_line_outliers(:, 2);
        %save these line inliers for later, since they are on a line, they
        %are outliers for the final circle and will be added to the final
        %outliers at the end
        to_add_later = [to_add_later ; best_line_inliers];
        
    else
        %if the circle is best, set the attributes of the circle to the
        %current attributes of the circle
        best_center = circ_center;
        best_inlier_list = best_circ_inliers;
        best_outlier_list = best_circ_outliers;
        %add all of the thrown out line inliers as final circle outliers
        best_outlier_list = [best_outlier_list ; to_add_later];
        %say that a circle has been found so the while loop will cease
        no_circ = false;
    end   
end