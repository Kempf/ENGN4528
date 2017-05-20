function [frame_out,colour_detected_rec] = Filter_Black(frame)

SE = strel('disk',4);

frame= imopen(frame,SE);
frame_out = bwareafilt(frame,[5,1000]);


region = regionprops(frame,'BoundingBox');
colour_detected_rec = [];

% figure(2)
% image(frame_out*1000)

for i = 1:size(region,1)
    area = region(i).BoundingBox(3) * region(i).BoundingBox(4);
    if (area <= 1000) && (area >= 10) &&...
              ((region(i).BoundingBox(4)/region(i).BoundingBox(3)) < 1.5) &&...
              ((region(i).BoundingBox(3)/region(i).BoundingBox(4)) < 1.5)
            
        region(i).BoundingBox = 2 * region(i).BoundingBox + [-4,-6,8,6];
        figure(1)
        rectangle('Position',region(i).BoundingBox,'EdgeColor','k','LineWidth',2);
        
        x = region(i).BoundingBox(1);
        y = region(i).BoundingBox(2);
        w = region(i).BoundingBox(3);
        h = region(i).BoundingBox(4);
%         
        if x < 1
            x = 1;
        end
        
        if y < 1
            y = 1;
        end
        
        if x+w >= 480
            w  = 480-x-1;
            
        end
        
        if y+h >= 320
            h = 320-y-1;
        end
        region(i).BoundingBox = [x,y,w,h];
        colour_detected_rec = [colour_detected_rec;region(i).BoundingBox];
    end
end

colour_detected_rec = round(colour_detected_rec);
end