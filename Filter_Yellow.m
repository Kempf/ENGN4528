function [coord,colour_detected_rec,rec_drawn] = Filter_Yellow(frame_py)
%pre-process
frame_ad = imadjust(frame_py,[ 0 0 0; 0.8 0.7 1],[]);
frame = CropColour(frame_ad,[255,255,255,255,20,100]);

SE = strel('rectangle',[8 5]);
frame = imclose(frame,SE);
BW = bwareafilt(frame,[12,200]);

region = regionprops(BW,'BoundingBox');
coord = [];
colour_detected_rec = [];
rec_drawn = [];

% if (size(region,1) ~= 0) && (size(region,1) < 6)
    for i = 1:size(region,1)
        area = region(i).BoundingBox(3) * region(i).BoundingBox(4);
        if (area <= 225) && (area >= 12) &&...
                ((region(i).BoundingBox(4)/region(i).BoundingBox(3)) < 1.4)&&...
                ((region(i).BoundingBox(3)/region(i).BoundingBox(4)) < 1.4)&&...
                (region(i).BoundingBox(1) >= 5) && (region(i).BoundingBox(2) >= 5)&&...
                (region(i).BoundingBox(1)+region(i).BoundingBox(3) <= 335)
        
            region(i).BoundingBox = 2*(region(i).BoundingBox);
            region(i).BoundingBox = region(i).BoundingBox + [-3,-3,5,5];
            coord = [coord;region(i).BoundingBox(1)+region(i).BoundingBox(3)/2,...
            region(i).BoundingBox(2)+region(i).BoundingBox(4)/2];
        figure(1)
            rec_drawn = rectangle('Position',region(i).BoundingBox,'EdgeColor','y','LineWidth',2);
            plot(coord(:,1),coord(:,2),'r*');
            colour_detected_rec = [colour_detected_rec;region(i).BoundingBox];
        end
        colour_detected_rec = round(colour_detected_rec);
    end
    
% end


end