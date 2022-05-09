function [best_center, best_inlier_list, best_outlier_list] = lineandcircransac(x, y, known_radius)

line_sigma = 0.001;
no_circ = true;
to_add_later = []
while no_circ
    
    [circ_center, best_circ_inliers, best_circ_outliers] = ransac_circ(x,y,known_radius);


    
    best_line_inliers = [];
    best_line_outliers = [];
    best_line = [];
    
    for j = 1:300
        
        p1 = randi(length(x));
        p2 = randi(length(x));
        while(p2 == p1)
            p2 = randi(length(x));
        end
    
        p1 = [x(p1) y(p1)];
        p2 = [x(p2) y(p2)];
        
        v =(p2-p1)';
        n = [-v(2); v(1)];
        nhat = n/norm(n);
        
        line_inliers = [];
        line_outliers = [];
        
        for k = 1:length(x)
            
            diff = [x(k, :) , y(k, :)] - p1;
            perp_distance = dot(diff,nhat);
            
            if abs(perp_distance) < line_sigma
                line_inliers = [line_inliers ; [x(k,:), y(k,:)]];
            else
                line_outliers = [line_outliers ; [x(k, :), y(k, :)]];
            end
        end
        %length(line_inliers)
            if length(line_inliers) > length(best_line_inliers)
                best_line_inliers = line_inliers;
                best_line_outliers = line_outliers;
                best_line = [p1;p2];
            end
        
    %checkikng if circle better than line
    end
    if length(best_line_inliers) > length(best_circ_inliers)
        %best_line_inliers
        %best_line_outliers
        x = best_line_outliers(:, 1);
        y = best_line_outliers(:, 2);
        to_add_later = best_line_inliers;
        
    else
        best_center = circ_center;
        best_inlier_list = best_circ_inliers;
        best_outlier_list = best_circ_outliers;
        best_outlier_list = [best_outlier_list ; to_add_later];
        no_circ = false;
    end
    plot(best_line(:,1), best_line(:,2),'b', 'linewidth', 2)
    plot(best_line_inliers(:,1), best_line_inliers(:, 2), 'g.')
    plot(best_line_outliers(:,1), best_line_outliers(:, 2), 'r.')
    
    
end
plot(best_center(1), best_center(2), 'mo')
