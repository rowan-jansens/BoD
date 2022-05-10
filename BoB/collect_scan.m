function [x, y] = collect_scan()
%collect a lidar scan, clean the data, and convert to cartesian
sub = rossubscriber('/scan');
scan_message = receive(sub);
r = scan_message.Ranges(1:end-1);
theta = deg2rad([0:359]');
index=find(r~=0);
r_clean=r(index);
theta_clean=theta(index);
[x,y]=pol2cart(theta_clean,r_clean);

end