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
clear

time = 0;
time1 = 0;

TIME_STEP = 64;

% get and enable devices, e.g.:
camera = wb_robot_get_device('camera');
wb_camera_enable(camera, TIME_STEP);
start_time = wb_robot_get_name;


motor_left_front = wb_robot_get_device('motor_left_front');
motor_left_back = wb_robot_get_device('motor_left_back');
motor_right_front = wb_robot_get_device('motor_right_front');
motor_right_back = wb_robot_get_device('motor_right_back');
distance_sensor = wb_robot_get_device('distance_sensor');
twister = wb_robot_get_device('twister');
pivot_1 = wb_robot_get_device('pivot_1');
pivot_2 = wb_robot_get_device('pivot_2');
pivot_3 = wb_robot_get_device('pivot_3');
finger_A = wb_robot_get_device('grabber finger A');
finger_B = wb_robot_get_device('grabber finger B');
finger_C = wb_robot_get_device('grabber finger C');

velocity = 2.5;
rotation_counter = 0;

Pivot_1 = -1.25;
Pivot_2 = -1.5;
Pivot_3 = -0.35;
grabber_pos = 0;

wb_motor_set_acceleration(motor_left_front, inf);
wb_motor_set_acceleration(motor_left_back, inf);
wb_motor_set_acceleration(motor_right_front, inf);
wb_motor_set_acceleration(motor_right_back, inf);

wb_motor_set_position(motor_left_front, inf);
wb_motor_set_velocity(motor_left_front, velocity);
wb_motor_set_position(motor_left_back, inf);
wb_motor_set_velocity(motor_left_back, velocity);

wb_motor_set_position(motor_right_front, inf);
wb_motor_set_velocity(motor_right_front, velocity);
wb_motor_set_position(motor_right_back, inf);
wb_motor_set_velocity(motor_right_back, velocity);

wb_motor_set_velocity(pivot_1, velocity);
wb_motor_set_velocity(pivot_2, velocity);
wb_motor_set_velocity(pivot_3, velocity);
wb_motor_set_velocity(finger_A, velocity);
wb_motor_set_velocity(finger_B, velocity);
wb_motor_set_velocity(finger_C, velocity);

%wb_motor_set_available_force(finger_A, 0.06)
%wb_motor_set_available_force(finger_B, 0.06)
%wb_motor_set_available_force(finger_C, 0.06)

wb_motor_enable_force_feedback(finger_A, TIME_STEP);

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
    if distance < 70 && distance > 30
        rotation_counter = randi([1 20], 1);  
    end

    my_image = wb_camera_get_image(camera);
    [display_out,tictac_count,IndexesOfMaxes,Pixels_left, Pixels_top] = camera_vision(my_image);
   
    wb_motor_set_position(pivot_1, Pivot_1);
    wb_motor_set_position(pivot_2, Pivot_2);
    wb_motor_set_position(pivot_3, Pivot_3);
    wb_motor_set_position(finger_A, grabber_pos);
    wb_motor_set_position(finger_B, grabber_pos);
    wb_motor_set_position(finger_C, grabber_pos);
     
    Horizontal_position = Pixels_left(IndexesOfMaxes);
    Vertical_position = Pixels_top(IndexesOfMaxes);
    position = Constants.Pickup_position;
    
%   Robot turns based on object pixel coordinates in image and stops when
%   TicTac is in right position to be picked up

%   If there is TicTac in image

        % Turn left
            if position(2) > (Horizontal_position + 30)
            
            wb_motor_set_velocity(motor_left_front, -(velocity));
            wb_motor_set_velocity(motor_left_back, -(velocity));
            
            elseif (position(2) > Horizontal_position) & (time1 < 5)
            time1 = time1 + 1;
            wb_motor_set_velocity(motor_left_front, 0);
            wb_motor_set_velocity(motor_left_back, 0);
            else
            wb_motor_set_velocity(motor_left_front, velocity);
            wb_motor_set_velocity(motor_left_back, velocity);
            end
        % Turn right
            if position(2) < (Horizontal_position - 30)
            wb_motor_set_velocity(motor_right_front, -(velocity));
            wb_motor_set_velocity(motor_right_back, -(velocity));
            elseif position(2) < Horizontal_position 
            wb_motor_set_velocity(motor_right_front, 0);
            wb_motor_set_velocity(motor_right_back, 0);
            else
            wb_motor_set_velocity(motor_right_front, velocity);
            wb_motor_set_velocity(motor_right_back, velocity);
            end
        % Stop
            if position(1) <= Vertical_position
            time1 = 0;  
            wb_motor_set_velocity(motor_left_front, 0);
            wb_motor_set_velocity(motor_left_back, 0);
            wb_motor_set_velocity(motor_right_front, 0);
            wb_motor_set_velocity(motor_right_back, 0);

        % Grabber movement    
            Pivot_1 = 1.25;
            Pivot_2 = 1.5;
            Pivot_3 = 0.37;
            grabber_pos = 0.7;
            end
            if distance < 21.5 && time < 8
            time = time + 1;
            grabber_pos = 0.1;
            end
            if time >= 8 && time < 32
            Pivot_1 = 0;
            Pivot_2 = -1.5;
            Pivot_3 = -1.5;
            time = time + 1;
            end
            if time == 32
            grabber_pos = 0.5;
            time = 0;
            end
    
    % if your code plots some graphics, it needs to flushed like this:
    drawnow;
end

% cleanup code goes here: write data to files, etc.
