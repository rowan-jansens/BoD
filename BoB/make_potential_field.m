function [X, Y, potential] = make_potential_field(x, y, inliers, outliers)

%make a localized meshgrid centerd on the neato's current position (which is
%always (0,0))
x_field = linspace(-4, 4, 81);
y_field = linspace(-4, 4, 81);
[X, Y] = meshgrid(x_field, y_field);

%define potential field scaling
inlier_scale = 8;
outlier_scale = 0.2;

%make empty field
potential = zeros(length(x_field), length(y_field));

%loop though eveery point in the meshgrid
    for i = 1:length(X)
        for j = 1:length(Y)
            %loop thought all of the inlier points....
            for k = 1:length(inliers)
                %... and sum up thier contibution to the potential field at
                %the curret point in the meshgrid
                potential(i, j) = potential(i,j) + inlier_scale*(log(sqrt((X(i,j) - inliers(k, 1))^2 + (Y(i,j) - inliers(k, 2))^2))); 
            end
            % do the same for the outlier points but make thier
            % contribution negative
            for k = 1:length(outliers)
                potential(i, j) = potential(i,j) - outlier_scale * (log(sqrt((X(i,j) - outliers(k, 1))^2 + (Y(i,j) - outliers(k, 2))^2)));
            end
        end
    end
end