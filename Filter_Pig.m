%% finds pigs
function [frame_out,region] = Filter_Pig(frame)
    SE = strel('disk',5);
    frame_out = imclose(frame,SE);
    region = regionprops(frame_out,'BoundingBox');
    
%     if (size(region,1) ~= 0) && (size(region,1) < 4)
        for i = 1:size(region,1)
            area = region(i).BoundingBox(3) * region(i).BoundingBox(4);
            if (area <= 700) && (area >= 120) &&(region(i).BoundingBox(3)<40)...
                    &&(region(i).BoundingBox(4)<40)
                region(i).BoundingBox(1) = region(i).BoundingBox(1) - 3;
                region(i).BoundingBox(2) = region(i).BoundingBox(2) - 3;
                region(i).BoundingBox(3) = region(i).BoundingBox(3) + 5;
                region(i).BoundingBox(4) = region(i).BoundingBox(4) + 5;
                rec = rectangle('Position',region(i).BoundingBox,'EdgeColor','g','LineWidth',4);
            end
        
        end
    
%     end


end