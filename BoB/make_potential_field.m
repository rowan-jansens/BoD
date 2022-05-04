function [X, Y, potential, grad_x, grad_y] = make_potential_field(x, y, inliers, outliers)
% x_field = linspace(min(x), max(x), 100);
% y_field = linspace(min(y), max(y), 100);

x_field = linspace(-5, 5, 50);
y_field = linspace(-5, 5, 50);
[X, Y] = meshgrid(x_field, y_field);


potential = zeros(length(x_field), length(y_field));
grad_x = zeros(length(x_field), length(y_field));
grad_y = zeros(length(x_field), length(y_field));

    for i = 1:length(X)
        for j = 1:length(Y)
            potential(i,j) = 0;
            grad_x(i,j) = 0;
            grad_y(i,j) = 0;

            for k = 1:length(inliers)
                potential(i, j) = potential(i,j) + log(sqrt((X(i,j) - inliers(k, 1))^2 + (Y(i,j) - inliers(k, 2))^2));
                grad_x = grad_x + (X(i, j) - inliers(k, 1)) / ((X(i, j) - inliers(k, 1))^2 + (Y(i, j) - inliers(k, 2))^2);
                grad_y = grad_y + (X(i, j) - inliers(k, 2)) / ((X(i, j) - inliers(k, 1))^2 + (Y(i, j) - inliers(k, 2))^2);
            end
            for k = 1:length(outliers)
                potential(i, j) = potential(i,j) - log(sqrt((X(i,j) - outliers(k, 1))^2 + (Y(i,j) - outliers(k, 2))^2));
                grad_x = grad_x + (X(i, j) + outliers(k, 1)) / ((X(i, j) - outliers(k, 1))^2 + (Y(i, j) - outliers(k, 2))^2);
                grad_y = grad_y + (X(i, j) + outliers(k, 2)) / ((X(i, j) - outliers(k, 1))^2 + (Y(i, j) - outliers(k, 2))^2);
            end
        end
    end

end