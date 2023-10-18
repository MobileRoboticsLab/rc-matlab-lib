function scan = simLidarScan(state, obstacles)

num_scans = 100;

scan = rosmessage("sensor_msgs/LaserScan");
scan.AngleMin = -pi;
scan.AngleMax = pi;
scan.AngleIncrement = 2*pi/num_scans;
scan.TimeIncrement = 1/num_scans;
scan.ScanTime = 1;
scan.RangeMin = 0.1;
scan.RangeMax = 10;
scan.Ranges = nan(1,num_scans);
scan.Intensities = ones(1, num_scans);

angles = scan.AngleMin:scan.AngleIncrement:scan.AngleMax;
angles = angles(1:num_scans);

rayResolution = 0.1;
ray_x = scan.RangeMin:rayResolution:scan.RangeMax;
ray_y = zeros(size(ray_x));
ray = [ray_x; ray_y];

rc_pos = [state(1); state(2)];
rc_heading = state(3);

R = @(theta) [cos(theta), -sin(theta); sin(theta), cos(theta)];

for i = 1:num_scans

    g_ray = R(angles(i) + rc_heading)*ray + rc_pos;

    min_idx = inf;
    for j = 1:numel(obstacles)
        inp = inpolygon(g_ray(1,:), g_ray(2,:), obstacles{j}(1,:), obstacles{j}(2,:));
        idx = find(inp, 1);
        if ~isempty(idx)
            if (idx < min_idx)
                min_idx = idx;
            end
        end
    end
    
    if min_idx ~= inf
        scan.Ranges(i) = ray_x(min_idx);
    else
        scan.Ranges(i) = 0;
    end
end

end