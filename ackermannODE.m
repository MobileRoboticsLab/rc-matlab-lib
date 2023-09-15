function dq = ackermannODE(~, q, u, L)

    % x = q(1)
    % y = q(2)
    theta = q(3);
    v = u(1);
    gamma = u(2);

    dx = v*cos(theta);
    dy = v*sin(theta);
    dtheta = v*tan(gamma) / L;

    dq = [dx; dy; dtheta];
end

