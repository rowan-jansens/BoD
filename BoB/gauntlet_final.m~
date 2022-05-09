%function res = gauntlet_final()
known_radius = 0.1329;
[x, y] = collect_scan();
[best_center, best_inlier_list, best_outlier_list] = ransac_circ(x, y, known_radius);
[X, Y, potential] = make_potential_field(x, y, best_inlier_list, best_outlier_list);
[dx, dy] = gradient(potential, 0.1);





%end