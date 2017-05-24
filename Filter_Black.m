function [coord,colour_detected_rec,rec_drawn] = Filter_Black(frame_py)
%pre-process
frame_ad = imadjust(frame_py,[.499 .499 .499; .501 .501 .501],[]);
frame = CropColour(frame_ad,[0,0,0,0,0,0]);

SE = strel('disk',4);
frame = imerode(frame,strel('rect',[5,1]));
frame = imerode(frame,strel('rect',[1,3]));
frame = imclose(frame,SE);
BW = bwareafilt(frame,[50,1000]);


region = regionprops(BW,'BoundingBox');
colour_detected_rec = [];
coord = [];
colour_detected_rec = [];
rec_drawn = [];

for i = 1:size(region,1)
     area = region(i).BoundingBox(3) * region(i).BoundingBox(4);
     if (area <= 2500) && (area >= 200) &&...
               ((region(i).BoundingBox(4)/region(i).BoundingBox(3)) < 1.7) &&...
               ((region(i).BoundingBox(3)/region(i).BoundingBox(4)) < 1.7) &&...
			   (region(i).BoundingBox(2) >= 55 && region(i).BoundingBox(2) <= 260)
        coord = [coord;region(i).BoundingBox(1)+region(i).BoundingBox(3),...
            region(i).BoundingBox(2)+region(i).BoundingBox(4)];
        figure(1)
        rec_drawn = rectangle('Position',region(i).BoundingBox,'EdgeColor','k','LineWidth',2);
        colour_detected_rec = [colour_detected_rec;region(i).BoundingBox];
%     end;
end
colour_detected_rec = round(colour_detected_rec);
end
