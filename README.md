# RC MATLAB Library

## RCCar

The RCCar class handles the communication with the vehicle using ROS. It contains methods to initiate and terminate control and planning loops, retrieve up-to-date lidar, occupancy, and odometry data, and adjust the vehicle's velocity and steering angle.

### Initialization

```
RC = RCCar(); % Create new RC connection with the default RC options
```
```
RC = RCCar(rcopts); % Create new RC connection with custom RC options
```

***Note:* Make sure the loops are stopped (`RC.stop`) before clearing the RC object. Otherwise, see `STOP` function.**

### Member Functions

| Function | Description | Note |
| -------- | ----------- | ---- |
| `RC.go()` | Start the control and planner loops | - |
| `RC.stop()` | Stop the control and planner loops | - |
| `RC.getPose()` | Get the latest vehicle pose | Returns a ROS `geometry_msgs/Pose` message |
| `RC.getMap()` | Get the latest occupancy map | Returns a ROS `nav_msgs/OccupancyGrid` message |
| `RC.getScan()` | Get the latest lidar scan | Returns a ROS `sensor_msgs/LaserScan` message |
| `RC.setServoPosition(positionValue)`| Set the servo position | Sets raw servo position, not steering angle. Use `setSteeringAngle()` for steering angle in radians.|
| `RC.setMotorSpeed(speedValue)` | Set the DC motor speed (in erpm) | Sets raw motor erpm, not vehicle velocity. Use `setSpeed()` for speed in meters per second. |

### Properties

| Property | Description | Note |
| -------- | ----------- | ---- |
| `LastState` | Last state of the vehicle | Automatically set |
| `CurrentState` | Current state of the vehicle | Automatically set |
| `NextState` | Predicted or desired next state | Set by User |
| `GoalState` | Target state the vehicle is trying to reach | Set by User |
| `DataLog<1-5>` | Utility properties for storing data from control loop | - |

*Note: States are represented in SE(2) (`[x; y; theta]`)*

## RCOptions

Struct of options used in the RCCar connection object.

### Properties

| Name | Description | Default |
| ---- | ----------- | ------- |
| `URI` | ROS Master URI | `"http://10.42.0.1:11311"` |
| `PlannerFcn` | Function handle executed in planner loop | `@TestPlannerFcn` |
| `ControlFcn` | Function handle executed in control loop | `@TestControlFcn` |
| `PlannerFreq` | Frequency of planner loop (in Hz) | `0.5` |
| `ControlFreq` | Frequency of control loop (in Hz) | `10` |
| `DriveGain` | [ERPM] to [m/s] gain | `3500` |
| `DriveOffset` | [ERPM] to [m/s] offset | `0` |
| `SteerGain` | [servo] to [rad] gain | `0.95` |
| `SteerOffset` | [servo] to [rad] offset | `0.40` |
| `SpeedLimit` | Max vehicle speed (in m/s) | `0.5` |
| `SpeedLimitReverse` | Max vehicle speed in reverse (in m/s) | `0.5` |
| `SteerLimitMax` | Max vehicle angle (in rad) | `+0.25` |
| `SteerLimitMin`| Min vehicle angle (in rad) | `-0.25` |

***NOTE:* DO NOT TOUCH SPEED OR ANGLE LIMITS >:(**

### Usage

```
% Create default RCOptions struct
rcopts = RCOptions();

% Use custom control function and rate
rcopts.ControlFcn = @MyControlFcn;
rcopts.ControlFreq = 15; % Hz

% Create RC connection with custom control
RC = RCCar(rcopts);
```

## Other Functions

| Function Name | Description |
| ------------- | ----------- |
| `showMap(RC)` | Display RC's latest occupancy map in a figure. |
| `resetMap(RC)` | Sends a command to reset the map and odometry. |
| `setSpeed(RC, speed)` | Sets the vehicle speed in meters per second. |
| `setSteeringAngle(RC, angle)` | Sets the steering angle in radians. |
| `getOccupancy(RC, x, y)` | Get the occupancy probability at a given x and y position. |
| `getDistancesInRange(RC, angle_min, angle_max)` | Get lidar scan distances between two angles. |
| `getDistanceToLeftWall(RC)` | Get the distance to the wall left of the vehicle. |
| `getDistanceToRightWall(RC)` | Get the distance to the wall right of the vehicle. |
| `poseToSE2(pose)` | Convert ROS `geometry_msgs/Pose` message type to a state vector in SE(2) space. |
| `STOP()` | Stops all loops in progress. If you forget to do `RC.stop()` before `clear`. |
| `TestControlFcn(RC)` | Default control loop function. Message indicates the control loop ran. |
| `TestPlannerFcn(RC)` | Default planner loop function. Message indicates the planner loop ran. |
