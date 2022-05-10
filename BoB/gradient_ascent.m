function res = gradient_ascent(gradValue, position, heading, pub, msg)
% to calculate wheel velocities for a given angular speed we need to know
% the wheel base of the robot
wheelBase = 0.235;              % meters
% this is the scaling factor we apply to the gradient when calculating our
% step size
lambda = 0.1;

% setup symbolic expressions for the function and gradient


% the problem description tells us to the robot starts at position 1, -1
% with a heading aligned to the y-axis

angularSpeed = 0.1; %.1 % radians / second (set higher than real to help with testing)
linearSpeed = 0.1; %.1 % meters / second

    crossProd = cross([heading; 0], [gradValue; 0]);

    % if the z-component of the crossProd vector is negative that means we
    % should be turning clockwise and if it is positive we should turn
    % counterclockwise
    turnDirection = sign(crossProd(3))

    % as stated above, we can get the turn angle from the relationship
    % between the magnitude of the cross product and the angle between the
    % vectors
    %turnAngle = asin(crossProd / norm(gradValue))
   turnAngle = acos(dot(heading, gradValue) / norm(gradValue))

    % this is how long in seconds to turn for
    turnTime = double(turnAngle) / angularSpeed;
    % note that we use the turnDirection here to negate the wheel speeds
    % when we should be turning clockwise instead of counterclockwise
    msg.Data = [-turnDirection*angularSpeed*wheelBase/2,

    turnDirection*angularSpeed*wheelBase/2];
    send(pub, msg);
    % record the start time and wait until the desired time has elapsed
    startTurn = rostic;
    while rostoc(startTurn) < turnTime
        pause(0.01);
    end
    msg.Data = [0,0];
    send(pub, msg);
    heading = gradValue / norm(gradValue);

    % this is how far we are going to move
    %forwardDistance = norm(gradValue*lambda);
    forwardDistance = lambda * norm(gradValue);
    % this is how long to take to move there based on desired linear speed
    forwardTime = forwardDistance / linearSpeed;
    % start the robot moving
    msg.Data = [linearSpeed, linearSpeed];
    send(pub, msg);
    % record the start time and wait until the desired time has elapsed
    startForward = rostic;
    while rostoc(startForward) < forwardTime
        pause(0.01)
    end
    msg.Data = [0,0];
    send(pub, msg);
    % update the position for the next iteration
    %position = position + (gradValue*lambda/norm(gradValue))
    position = position + (gradValue*lambda)
    % if our step is too short, flag it so we break out of our loop

end