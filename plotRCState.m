function display = plotRCState(RC, display)
    
    if isempty(RC.CurrentState)
        return
    end

    %% CAR INFO

    carWidth = 0.45; % m
    carLength = 0.75; % m

    G_trans_RC = RC.CurrentState(1:2); % x, y
    theta = RC.CurrentState(3); % theta
    gamma = (RC.CurrentControl(2) - RC.Options.SteerOffset) / RC.Options.SteerGain; % gamma

    % Change of frame
    body_RC = [+carLength/2, -carLength/2, -carLength/2 , +carLength/2;
               +carWidth/2, +carWidth/2, -carWidth/2, -carWidth/2];

    G_rot_RC = [cos(theta), -sin(theta);
                sin(theta), cos(theta)]; 

    body_G = G_rot_RC * body_RC + G_trans_RC;


    %% WHEEL INFO

    wheelWidth = 0.15; % m
    wheelLength = 0.3; % m
    wheelOffsetX = 0.3; % m
    wheelOffsetY = 0.2; % m

    wheel = [+wheelLength/2, -wheelLength/2, -wheelLength/2 , +wheelLength/2;
               +wheelWidth/2, +wheelWidth/2, -wheelWidth/2, -wheelWidth/2];

    RC_trans_W1 = [+wheelOffsetX; +wheelOffsetY];
    RC_trans_W2 = [-wheelOffsetX; +wheelOffsetY];
    RC_trans_W3 = [-wheelOffsetX; -wheelOffsetY];
    RC_trans_W4 = [+wheelOffsetX; -wheelOffsetY];

    FW_rot_RC = [cos(gamma), -sin(gamma);
                 sin(gamma), cos(gamma)];

    wheelFL_G = (G_rot_RC * ((FW_rot_RC * wheel) + RC_trans_W1)) + G_trans_RC;
    wheelBL_G = (G_rot_RC * (wheel + RC_trans_W2)) + G_trans_RC;
    wheelBR_G = (G_rot_RC * (wheel + RC_trans_W3)) + G_trans_RC;
    wheelFR_G = (G_rot_RC * ((FW_rot_RC * wheel) + RC_trans_W4)) + G_trans_RC;
    

    %% PLOT

    if isempty(display)
        hold on
        grid on
        display = [];
        display(1) = fill(body_G(1,:), body_G(2,:), 'g'); % car plot
        display(2) = fill(wheelFL_G(1,:), wheelFL_G(2,:), 'k'); % Front Left
        display(3) = fill(wheelBL_G(1,:), wheelBL_G(2,:), 'k'); % Back Left
        display(4) = fill(wheelBR_G(1,:), wheelBR_G(2,:), 'k'); % Back Right
        display(5) = fill(wheelFR_G(1,:), wheelFR_G(2,:), 'k'); % Front Right
    else
        set(display(1), 'xdata', body_G(1,:), 'ydata', body_G(2,:))
        set(display(2), 'xdata', wheelFL_G(1,:), 'ydata', wheelFL_G(2,:))
        set(display(3), 'xdata', wheelBL_G(1,:), 'ydata', wheelBL_G(2,:))
        set(display(4), 'xdata', wheelBR_G(1,:), 'ydata', wheelBR_G(2,:))
        set(display(5), 'xdata', wheelFR_G(1,:), 'ydata', wheelFR_G(2,:))
    end

    halfWindowSize = 1.5;
    axis([G_trans_RC(1) - halfWindowSize, ...
          G_trans_RC(1) + halfWindowSize, ...
          G_trans_RC(2) - halfWindowSize, ...
          G_trans_RC(2) + halfWindowSize]);

end

