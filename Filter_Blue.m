%% finds blues - it's pretty bad
function [frame_out,colour_detected_rec] = Filter_Blue(frame,rgbframe)
SE = strel('rectangle',[8,4]);
frame_out = imclose(frame,SE);
frame_out = bwareafilt(frame_out,[20,500]);

region = regionprops(frame_out,'BoundingBox');
colour_detected_rec = [];

for i = 1:size(region,1)
    area = region(i).BoundingBox(3)*region(i).BoundingBox(4);
    %region(i).BoundingBox = region(i).BoundingBox + [-5,-3,10,5];
    
    if (area <= 300) && (area >= 70) &&...
            ((region(i).BoundingBox(4)/region(i).BoundingBox(3)) < 1.8)&&...
            ((region(i).BoundingBox(3)/region(i).BoundingBox(4)) < 1.8)&&...
            (region(i).BoundingBox(1) >= 10) && (region(i).BoundingBox(2) >= 60)
            
        % second color filter
        window = CropColour(imcrop(rgbframe,region(i).BoundingBox),[200,255,120,200,0,0]);
        if sum(window(:)) >= 3
            %region(i).BoundingBox = region(i).BoundingBox + [-3,-3,5,5];
            rec = rectangle('Position',region(i).BoundingBox,'EdgeColor','b','LineWidth',2);
            colour_detected_rec = [colour_detected_rec;region(i).BoundingBox];
        end
    end
end

colour_detected_rec = round(colour_detected_rec);

end