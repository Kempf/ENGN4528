function [coord,colour_detected_rec,rec_drawn] = Filter_Pig(frame_py)
%pre-process
frame_ad = imadjust(frame_py,[ 0 .499 0.2; 1 .501 0.8],[]);
frame = CropColour(frame_ad,[100,150,255,255,0,100]);

SE = strel('rectangle',[5 5]);
frame = imclose(frame,SE);
BW = bwareafilt(frame,[25,225]);

region = regionprops(BW,'BoundingBox');
coord = [];
colour_detected_rec = [];
rec_drawn = [];
% if (size(region,1) ~= 0) && (size(region,1) < 6)
for i = 1:size(region,1)
    area = region(i).BoundingBox(3) * region(i).BoundingBox(4);
    if (area <= 225) && (area >= 25) &&...
            ((region(i).BoundingBox(4)/region(i).BoundingBox(3)) < 1.3)&&...
            ((region(i).BoundingBox(3)/region(i).BoundingBox(4)) < 1.3)&&...
            (region(i).BoundingBox(1) >= 5) && (region(i).BoundingBox(2) >= 5)&&...
            (region(i).BoundingBox(1)+region(i).BoundingBox(3) <= 235)
        window = CropColour(imcrop(frame_py,region(i).BoundingBox),[70,100,0,0,0,0]);
        if sum(window(:)) <= 5
            region(i).BoundingBox = 2*region(i).BoundingBox;% + [-3,-3,5,5];
            coord = [coord;region(i).BoundingBox(1)+region(i).BoundingBox(3)/2,...
                region(i).BoundingBox(2)+region(i).BoundingBox(4)/2];
            figure(1)
            rec_drawn = rectangle('Position',region(i).BoundingBox,'EdgeColor','g','LineWidth',2);
            plot(coord(:,1),coord(:,2),'r*');
            colour_detected_rec = [colour_detected_rec;region(i).BoundingBox];
        end
    end
end
colour_detected_rec = round(colour_detected_rec);
end