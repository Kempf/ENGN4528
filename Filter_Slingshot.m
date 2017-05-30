function [coord,rec_drawn] = Filter_Slingshot(frame)
%The algorith is the same as Filter_Red, but is for 
%brown pixels to detect the slingshot

coord = [];
rec_drawn = [];

frame = CropColour(frame,[120,190,70,160,37,100]);


if sum(frame(:)) < 10
    return
end

frame = imclose(frame,strel('rectangle',[15,1]));
BW= bwareafilt(frame,[25,2500]);

region = regionprops(BW,'BoundingBox');

for i = 1:size(region,1)
    area = region(i).BoundingBox(3) * region(i).BoundingBox(4);
    if  (region(i).BoundingBox(4)/region(i).BoundingBox(3)) > 2.4 &&...
            area > 1000 &&...
            region(i).BoundingBox(1) < 200
       
        coord = [coord;region(i).BoundingBox(1)+region(i).BoundingBox(3)/2,...
            region(i).BoundingBox(2)+region(i).BoundingBox(4)];
        figure(1)
        %draw a line that indicates the position of slingshot
         line([region(i).BoundingBox(1)+region(i).BoundingBox(3)/2,region(i).BoundingBox(1)+region(i).BoundingBox(3)/2],...
             [region(i).BoundingBox(2),region(i).BoundingBox(2)+region(i).BoundingBox(4)],'Color','m','LineWidth',4)

    end
end





end
