function [display_out, tictac_count,IndexesOfMaxes, Pixels_left, Pixels_top] = camera_vision(my_image)
%camera_vision Object detection using camera
%  Image acquisition, procesing and detection of objects(tictacs) and
%  moving robot for grabber reach

%   process image from camera
    gray = rgb2gray(my_image);
    BW = segmentImage(gray);
%   load data from procesed image
    properties = filterRegions(BW);
    [tictac_count, ~] = size(properties);
    
    Boxes = zeros(tictac_count,4);
    Pixels_left= zeros(tictac_count,1);
    Pixels_top = zeros(tictac_count,1);
%   safe BoundingBox(renctangle coordinates) from properties
    for i = 1:tictac_count
    Boxes(i,:) = properties(i).BoundingBox;
    Pixels_left(i) = (2*Boxes(i,1) + Boxes(i,3))/2;
    Pixels_top(i) = (2*Boxes(i,2) + Boxes(i,4))/2;
    end
    [~, IndexesOfMaxes] = max(Pixels_top(:));
%   display Bounding boxes into our camera image which surrounds our objects 
    display_out = insertShape(my_image,'rectangle', [Boxes], 'Color', {'white'});
    imshow(display_out);
    axis on
    hold on;
    % Plot crosses which indicates center of our objects
    plot(Pixels_left(1:tictac_count),Pixels_top(1:tictac_count), 'r+', 'MarkerSize', 20, 'LineWidth', 1);
    % Plot cros at pickup position
    plot(Constants.Pickup_position,Constants.Pickup_position, 'b+', 'MarkerSize', 30, 'LineWidth', 2);

    end