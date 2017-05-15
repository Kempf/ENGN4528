function [frame_out,colour_detected_rec] = Filter_White(frame)

SE = strel('rectangle',[3 3]);
%frame_out = imclose(frame,SE);
frame_out = imopen(frame,SE);
frame_out = bwareafilt(frame_out,[90,500]);

region = regionprops(frame_out,'BoundingBox');
colour_detected_rec = [];
% if (size(region,1) ~= 0) && (size(region,1) < 6)
    for i = 1:size(region,1)
        area = region(i).BoundingBox(3) * region(i).BoundingBox(4);
        if (area <= 900) && (area >= 100) &&...
            ((region(i).BoundingBox(4)/region(i).BoundingBox(3)) < 1.7)&&...
            ((region(i).BoundingBox(3)/region(i).BoundingBox(4)) < 1.7)&&...
            (region(i).BoundingBox(1) >= 5) && (region(i).BoundingBox(2) >= 5)&&...
            (region(i).BoundingBox(1)+region(i).BoundingBox(3) <= 770)

            region(i).BoundingBox = region(i).BoundingBox + [-3,-3,5,5];
            rec = rectangle('Position',region(i).BoundingBox,'EdgeColor','b','LineWidth',4);
            colour_detected_rec = [colour_detected_rec;region(i).BoundingBox];
         % else
%             clc
%             disp('No Rectangle')
             % fprintf('AREA: %d \n',area)
             % fprintf('x width: %d \n',region(i).BoundingBox(3))
             % fprintf('y width: %d \n',region(i).BoundingBox(4))
             % fprintf('y/x: %.3f \n',region(i).BoundingBox(4)/region(i).BoundingBox(3))
             % fprintf('x/y: %.3f \n',region(i).BoundingBox(3)/region(i).BoundingBox(4))
             % pause
%             
%             
%             
        end
        
    end
    
% end


end