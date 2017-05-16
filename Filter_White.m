function [frame_out,colour_detected_rec] = Filter_White(frame,rgbframe)

SE = strel('rectangle',[3 3]);
%frame_out = imclose(frame,SE);
frame_out = imopen(frame,SE);
frame_out = bwareafilt(frame_out,[90,500]);

region = regionprops(frame_out,'BoundingBox');
colour_detected_rec = [];
% if (size(region,1) ~= 0) && (size(region,1) < 6)
    for i = 1:size(region,1)
        area = region(i).BoundingBox(3) * region(i).BoundingBox(4);
        if (area <= 1000) && (area >= 100) &&...
            ((region(i).BoundingBox(4)/region(i).BoundingBox(3)) < 1.9)&&...
            ((region(i).BoundingBox(3)/region(i).BoundingBox(4)) < 1.9)&&...
            (region(i).BoundingBox(1) >= 5) && (region(i).BoundingBox(2) >= 5)&&...
            (region(i).BoundingBox(2) <= 210)&&...
            (region(i).BoundingBox(1)+region(i).BoundingBox(3) <= 770)
            
            region(i).BoundingBox = region(i).BoundingBox + [-3,-13,5,15];
            
            window = CropColour(imcrop(rgbframe,region(i).BoundingBox),[255,255,200,250,100,190]);
            if sum(window(:)) >= 10
                rec = rectangle('Position',region(i).BoundingBox,'EdgeColor','b','LineWidth',4);
                colour_detected_rec = [colour_detected_rec;region(i).BoundingBox];
            end
        end
        
    end
    
% end


end