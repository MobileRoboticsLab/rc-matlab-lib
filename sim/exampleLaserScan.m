function scan = exampleLaserScan()

scan = rosmessage("sensor_msgs/LaserScan");
scan.AngleMin = -pi;
scan.AngleMax = pi;
scan.AngleIncrement = pi/100;
scan.TimeIncrement = 1/100;
scan.ScanTime = 1;
scan.RangeMin = 0;
scan.RangeMax = 50;
scan.Ranges = ones(1,100)*25;
scan.Intensities = ones(1, 100);

end

