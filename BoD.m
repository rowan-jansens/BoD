function BoD()
clear; clc;
diam = 0.235;
beta = .2;
t_max = 3.2 / beta;
% Insert any setup code you want to run here

% u will be our parameter
syms t;

% this is the equation of the bridge

ri=4*0.3960*cos(2.65*(t * beta+1.4));
rj=4*-0.99*sin(t * beta+1.4);
rk=0*t;
r=[ri,rj,rk];


v = diff(r, t);

T_hat = (v ./ norm(v));
dT_hat = diff(T_hat, t);
N_hat = (dT_hat ./ norm(dT_hat));
omega = cross(T_hat, dT_hat);

V_right = norm(v) + omega(3) .* (diam/2);
V_left = norm(v) - omega(3) .* (diam/2);






pub = rospublisher('raw_vel');

% stop the robot if it's going right now
stopMsg = rosmessage(pub);
stopMsg.Data = [0, 0];
runMsg = rosmessage(pub);
runMsg.Data = [0, 0];
send(pub, stopMsg);

bridgeStart = double(subs(r,t,0));
startingThat = double(subs(T_hat,t,0));
placeNeato(bridgeStart(1),  bridgeStart(2), startingThat(1), startingThat(2));

% wait a bit for robot to fall onto the bridge
pause(2);

rostic;

while true
    elapsedTime = rostoc
    eval(subs(V_left, t, elapsedTime));
    eval(subs(V_right, t, elapsedTime));
    
    runMsg.Data = [double(eval(subs(V_left, t, elapsedTime))), double(eval(subs(V_right, t, elapsedTime)))]; 
    send(pub, runMsg);
    if elapsedTime >= t_max
        break
    end
    disp(['Elapsed Time: ', num2str(elapsedTime)]);
end
  

msg.Data = [0, 0];
send(pub, msg);

end


