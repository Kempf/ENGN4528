function [frame_out,colour_detected_rec] = Filter(frame)

%only takes the pixel clusters that are within this threshold

% SE = strel('rectangle',[2,2]);
% frame_out = imopen(frame,SE);
% SE = strel('disk',3);
SE = strel('rectangle',[3,3]);
frame_out = imclose(frame,SE);

% frame_out = imdilate(frame_out,SE);
region  = regionprops(frame_out,'BoundingBox');
colour_detected_rec = [];
if (size(region,1) ~= 0) && (size(region,1) < 5)
    for i = 1:size(region,1)
        area = region(i).BoundingBox(3) * region(i).BoundingBox(4);
        if (area <= 600) && (area >= 50) &&...
            ((region(i).BoundingBox(4)/region(i).BoundingBox(3)) < 1.4)&&...
            ((region(i).BoundingBox(3)/region(i).BoundingBox(4)) < 1.4)&&...
            (region(i).BoundingBox(1) >= 10) && (region(i).BoundingBox(2) >= 10) 
            region(i).BoundingBox = region(i).BoundingBox + [-5,-3,10,8];
            rec = rectangle('Position',region(i).BoundingBox,'EdgeColor','r','LineWidth',2);
            colour_detected_rec = [colour_detected_rec;region(i).BoundingBox];
        else 
            region(i).BondingBox = 0;
        end
        
    end
end

colour_detected_rec = round(colour_detected_rec);


end