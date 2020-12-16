% MATLAB controller for Webots
% File:          my_controller.m
% Date:
% Description:
% Author:
% Modifications:

% uncomment the next two lines if you want to use
% MATLAB's desktop to interact with the controller:
% desktop;
% keyboard;

TIME_STEP = 64;

% get and enable devices, e.g.:
camera = wb_robot_get_device('camera');
wb_camera_enable(camera, TIME_STEP);

motor_left_front = wb_robot_get_device('motor_left_front');
motor_left_back = wb_robot_get_device('motor_left_back');
motor_right_front = wb_robot_get_device('motor_right_front');
motor_right_back = wb_robot_get_device('motor_right_back');
distance_sensor = wb_robot_get_device('distance_sensor');
twister = wb_robot_get_device('twister');
pivot_1 = wb_robot_get_device('pivot_1');
pivot_2 = wb_robot_get_device('pivot_2');
grabber = wb_robot_get_device('grabber');

velocity = 5;
rotation_counter = 0;


wb_motor_set_position(motor_left_front, inf);
wb_motor_set_velocity(motor_left_front, velocity);
wb_motor_set_position(motor_left_back, inf);
wb_motor_set_velocity(motor_left_back, velocity);
wb_motor_set_position(motor_right_front, inf);
wb_motor_set_velocity(motor_right_front, velocity);
wb_motor_set_position(motor_right_back, inf);
wb_motor_set_velocity(motor_right_back, velocity);
wb_motor_set_position(pivot_1, 3);
wb_motor_set_velocity(pivot_1, velocity);
wb_motor_set_position(pivot_2, 3);
wb_motor_set_velocity(pivot_2, velocity);

wb_distance_sensor_enable(distance_sensor, TIME_STEP);

% main loop:
% perform simulation steps of TIME_STEP milliseconds
% and leave the loop when Webots signals the termination
%
while wb_robot_step(TIME_STEP) ~= -1
    distance = wb_distance_sensor_get_value(distance_sensor);
    if rotation_counter > 0
        rotation_counter = rotation_counter - 1;
        wb_motor_set_velocity(motor_right_front, -(velocity));
        wb_motor_set_velocity(motor_right_back, -(velocity));
    else
        wb_motor_set_velocity(motor_right_front, velocity);
        wb_motor_set_velocity(motor_right_back, velocity);
    end
    if distance < 100
        rotation_counter = randi([1 20], 1);
    end
    
    disp(distance)
    
    my_image = wb_camera_get_image(camera);
    imshow(my_image)
    
    % read the sensors, e.g.:
    
    % Process here sensor data, images, etc.
    
    % send actuator commands, e.g.:
    %  wb_motor_set_postion(motor, 10.0);
    
    % if your code plots some graphics, it needs to flushed like this:
    drawnow;
end

% cleanup code goes here: write data to files, etc.
