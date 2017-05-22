function [coord,colour_detected_rec,rec_drawn] = Filter_Slingshot(frame_py)

%pre-process
frame = CropColour(frame_py,[120,190,70,160,37,100]);

SE = strel('rectangle',[15,1]);
frame = imclose(frame,SE);
BW= bwareafilt(frame,[25,2500]);

region = regionprops(BW,'BoundingBox');
coord = [];
colour_detected_rec = [];
rec_drawn = [];

for i = 1:size(region,1)
    region(i).BoundingBox = 2*(region(i).BoundingBox);
    if (region(i).BoundingBox(4)/region(i).BoundingBox(3)) > 2.4 &&...
            (region(i).BoundingBox(4)/region(i).BoundingBox(3))<3.5&&...
            region(i).BoundingBox(4) <150
        coord = [coord;region(i).BoundingBox(1)+region(i).BoundingBox(3)/2,...
            region(i).BoundingBox(2)+region(i).BoundingBox(4)/2];
        figure(1)
         rec_drawn = rectangle('Position',region(i).BoundingBox,'EdgeColor','m','LineWidth',2);
          
         colour_detected_rec = [colour_detected_rec;region(i).BoundingBox];
    end
end

colour_detected_rec = round(colour_detected_rec);



end