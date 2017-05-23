function [coord,colour_detected_rec,rec_drawn] = Filter_Yellow(frame)
%pre-process
% frame_ad = imadjust(frame_py,[ 0 0 0; 0.8 0.7 1],[]);
BW = CropColour(frame,[200,255,200,255,20,100]);

% BW = bwareafilt(BW,[12,200]);

SE = strel('disk',5);
BW = imclose(BW,SE);
% figure(2)
% image(BW*1000)

region = regionprops(BW,'BoundingBox');
coord = [];
colour_detected_rec = [];
rec_drawn = [];

    for i = 1:size(region,1)
        area = region(i).BoundingBox(3) * region(i).BoundingBox(4);
        if (area <= 600) && (area >= 100) &&...
                ((region(i).BoundingBox(4)/region(i).BoundingBox(3)) < 1.4)&&...
                ((region(i).BoundingBox(3)/region(i).BoundingBox(4)) < 1.4)&&...
                (region(i).BoundingBox(1) >= 5) && (region(i).BoundingBox(2) >= 5)&&...
                (region(i).BoundingBox(1)+region(i).BoundingBox(3) <= 335)
       
            region(i).BoundingBox = region(i).BoundingBox + (area/120)*[-3,-3,5,5];
            coord = [coord;region(i).BoundingBox(1)+region(i).BoundingBox(3)/2,...
            region(i).BoundingBox(2)+region(i).BoundingBox(4)/2];
        figure(1)
            rec_drawn = rectangle('Position',region(i).BoundingBox,'EdgeColor','y','LineWidth',2);
            colour_detected_rec = [colour_detected_rec;region(i).BoundingBox];
        end
        colour_detected_rec = round(colour_detected_rec);
    end

end
