function [coord,colour_detected_rec,rec_drawn] = Filter_Black(frame_py)
%pre-process
frame_ad = imadjust(frame_py,[.499 .499 .499; .501 .501 .501],[]);
frame = CropColour(frame_ad,[0,0,0,0,0,0]);

SE = strel('disk',3);

frame= imclose(frame,SE);
BW = bwareafilt(frame,[40,200]);

region = regionprops(BW,'BoundingBox');
colour_detected_rec = [];
coord = [];
colour_detected_rec = [];
rec_drawn = [];

for i = 1:size(region,1)
%     area = region(i).BoundingBox(3) * region(i).BoundingBox(4);
%     if (area <= 2500) && (area >= 4) &&...
%               ((region(i).BoundingBox(4)/region(i).BoundingBox(3)) < 1.5) &&...
%               ((region(i).BoundingBox(3)/region(i).BoundingBox(4)) < 1.5)
        region(i).BoundingBox = 2*(region(i).BoundingBox);
        coord = [coord;region(i).BoundingBox(1)+region(i).BoundingBox(3)/2,...
            region(i).BoundingBox(2)+region(i).BoundingBox(4)/2];
        figure(1)
        rec_drawn = rectangle('Position',region(i).BoundingBox,'EdgeColor','k','LineWidth',2);
        plot(coord(:,1),coord(:,2),'r*');
        colour_detected_rec = [colour_detected_rec;region(i).BoundingBox];
%     end;
end
colour_detected_rec = round(colour_detected_rec);
end