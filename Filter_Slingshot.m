function [frame_out,colour_detected_rec] = Filter_Slingshot(frame)
SE = strel('rectangle',[30,2]);


frame_out = bwareafilt(frame,[100,1000]);

frame_out = imclose(frame_out,SE);

region = regionprops(frame_out,'BoundingBox');

colour_detected_rec = [];

for i = 1:size(region,1)
    if (region(i).BoundingBox(4)/region(i).BoundingBox(3)) > 2.4 &&...
            region(i).BoundingBox(3)*region(i).BoundingBox(4) > 100
         rec = rectangle('Position',region(i).BoundingBox,'EdgeColor','m','LineWidth',2);
         colour_detected_rec = [colour_detected_rec;region(i).BoundingBox];
    end


end

colour_detected_rec = round(colour_detected_rec);



end