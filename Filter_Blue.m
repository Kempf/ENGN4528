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
    if (region(i).BoundingBox(4)/region(i).BoundingBox(3)) < 2.5 &&...
        (region(i).BoundingBox(3)/region(i).BoundingBox(4)) < 2.5&&...
        (area > 10) && (area<300)
    
        
        
        rec = rectangle('Position',region(i).BoundingBox,'EdgeColor','b','LineWidth',2);
        colour_detected_rec = [colour_detected_rec;region(i).BoundingBox];
    end
end

colour_detected_rec = round(colour_detected_rec);

end