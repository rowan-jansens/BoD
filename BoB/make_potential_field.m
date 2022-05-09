function [X, Y, potential] = make_potential_field(x, y, inliers, outliers)

x_field = linspace(-1, 1, 21);
y_field = linspace(-1, 1, 21);
[X, Y] = meshgrid(x_field, y_field);


potential = zeros(length(x_field), length(y_field));


    for i = 1:length(X)
        for j = 1:length(Y)
            potential(i,j) = 0;
            grad_x(i,j) = 0;
            grad_y(i,j) = 0;

            for k = 1:length(inliers)
                potential(i, j) = potential(i,j) + log(sqrt((X(i,j) - inliers(k, 1))^2 + (Y(i,j) - inliers(k, 2))^2)); 
            end
            for k = 1:length(outliers)
                potential(i, j) = potential(i,j) - log(sqrt((X(i,j) - outliers(k, 1))^2 + (Y(i,j) - outliers(k, 2))^2));
            end
        end
    end

end