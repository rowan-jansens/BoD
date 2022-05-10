function path_points = predict_path(dx, dy, start_pos, center, known_rad)

pos = start_pos';
path_points = [];
lambda = 0.03;
for i = 1:100
    path_points(end+1,:) = pos;
    pos_x_idx = round(41 + (pos(1) * 10))
    pos_y_idx = round(41 + (pos(2) * 10))
    gradient = [dx(pos_y_idx, pos_x_idx), dy(pos_y_idx, pos_x_idx)];
    gradient = gradient / norm(gradient);

    
    pos(1) = pos(1) + -1*lambda*gradient(1);
    pos(2) = pos(2) + -1*lambda*gradient(2);
    
    if sqrt((pos(1) - center(1))^2 + (pos(2) - center(2))^2) < known_rad + 0.05
        break
    end
    
end
end