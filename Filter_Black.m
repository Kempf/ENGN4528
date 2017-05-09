function [frame_out,colour_detected_rec] = Filter_Black(frame)

SE = strel('rectangle',[5,5]);

frame= imdilate(frame,SE);
frame_out = bwareafilt(frame,[300,1000]);
region = regionprops(frame,'BoundingBox');
colour_detected_rec = [];

if (size(region,1) ~= 0) && (size(region,1) < 8)
    
    for i = 1:size(region,1)
        area = region(i).BoundingBox(3) * region(i).BoundingBox(4);
        if (area <= 1000) && (area >= 100) &&(region(i).BoundingBox(3)<50)...
                &&(region(i).BoundingBox(4)<50)...
                &&((region(i).BoundingBox(4)/region(i).BoundingBox(3)) < 1.4)...
                &&((region(i).BoundingBox(3)/region(i).BoundingBox(4)) < 1.4)...
                &&(region(i).BoundingBox(1) >= 10) && (region(i).BoundingBox(2) >= 10)
            region(i).BoundingBox = region(i).BoundingBox + [-3,-3,5,5];
            rec = rectangle('Position',region(i).BoundingBox,'EdgeColor','k','LineWidth',2);
            colour_detected_rec = [colour_detected_rec;region(i).BoundingBox];
            %             else
            %                 clc
            %                 disp('No Rectangle')
            %                 fprintf('AREA: %d \n',area)
            %                 fprintf('x width: %d \n',region(i).BoundingBox(3))
            %                 fprintf('y width: %d \n',region(i).BoundingBox(4))
            %                 fprintf('y/x: %.3f \n',region(i).BoundingBox(4)/region(i).BoundingBox(3))
            %                 fprintf('x/y: %.3f \n',region(i).BoundingBox(3)/region(i).BoundingBox(4))
            %                 pause(2)
        end
        
    end
end
colour_detected_rec = round(colour_detected_rec);

end