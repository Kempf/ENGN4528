function [coord,colour_detected_rec,rec_drawn] = Filter_Slingshot(frame)
SE = strel('rectangle',[30,2]);
coord = [];
rec_drawn = [];
frame_out = bwareafilt(frame,[100,1000]);

frame_out = imclose(frame_out,SE);

region = regionprops(frame_out,'BoundingBox');

colour_detected_rec = [];

for i = 1:size(region,1)
    if (region(i).BoundingBox(4)/region(i).BoundingBox(3)) > 2.4 &&...
            region(i).BoundingBox(3)*region(i).BoundingBox(4) > 100
         rec_drawn = rectangle('Position',region(i).BoundingBox,'EdgeColor','m','LineWidth',2);
          coord = [coord;region(i).BoundingBox(1)+region(i).BoundingBox(3)/2,...
            region(i).BoundingBox(2)+region(i).BoundingBox(4)/2];
         colour_detected_rec = [colour_detected_rec;region(i).BoundingBox];
    end
end

colour_detected_rec = round(colour_detected_rec);



end