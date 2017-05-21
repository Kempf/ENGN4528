%% finds pigs
function [frame_out,colour_detected_rec] = Filter_Pig(frame,rgbframe)
SE = strel('rectangle',[5 5]);
frame_out = imclose(frame,SE);
frame_out = bwareafilt(frame_out,[100,900]);

region = regionprops(frame_out,'BoundingBox');
colour_detected_rec = [];
% if (size(region,1) ~= 0) && (size(region,1) < 6)
    for i = 1:size(region,1)
        area = region(i).BoundingBox(3) * region(i).BoundingBox(4);
        if (area <= 900) && (area >= 100) &&...
            ((region(i).BoundingBox(4)/region(i).BoundingBox(3)) < 1.3)&&...
            ((region(i).BoundingBox(3)/region(i).BoundingBox(4)) < 1.3)&&...
            (region(i).BoundingBox(1) >= 10) && (region(i).BoundingBox(2) >= 10)&&...
            (region(i).BoundingBox(1)+region(i).BoundingBox(3) <= 470)
            
            region(i).BoundingBox = region(i).BoundingBox + [-3,-3,5,5];
            window = CropColour(imcrop(rgbframe,region(i).BoundingBox),[70,100,0,0,0,0]);
            if sum(window(:)) <= 10
                rec = rectangle('Position',region(i).BoundingBox,'EdgeColor','g','LineWidth',4);
                colour_detected_rec = [colour_detected_rec;region(i).BoundingBox];
            end
        end
        
    end
    
% end


end