%% finds blues - it's pretty bad
function [frame_out,colour_detected_rec] = Filter_Blue(frame)
SE = strel('rectangle',[4,4]);
frame_out = bwareafilt(frame,[10,inf]);
frame_out = imclose(frame,SE);


region = regionprops(frame_out,'BoundingBox');
colour_detected_rec = [];

for i = 1:size(region,1)
    area = region(i).BoundingBox(3)*region(i).BoundingBox(4);
    region(i).BoundingBox = region(i).BoundingBox + [-5,-3,10,5];
    
    if (area <= 300) && (area >= 10) &&...
            ((region(i).BoundingBox(4)/region(i).BoundingBox(3)) < 1.4)&&...
            ((region(i).BoundingBox(3)/region(i).BoundingBox(4)) < 1.4)&&...
            (region(i).BoundingBox(1) >= 10) && (region(i).BoundingBox(2) >= 10)&&...
            (region(i).BoundingBox(1)+region(i).BoundingBox(3) <= 470)
        
        
        rec = rectangle('Position',region(i).BoundingBox,'EdgeColor','b','LineWidth',2);
        colour_detected_rec = [colour_detected_rec;region(i).BoundingBox];
    end
end

colour_detected_rec = round(colour_detected_rec);

end