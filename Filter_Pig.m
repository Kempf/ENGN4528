function [coord,colour_detected_rec,rec_drawn] = Filter_Pig(frame)
%pre-process

BW = CropColour(frame,[100,180,200,255,50,150]);

coord = [];
colour_detected_rec = [];
rec_drawn = [];
if sum(BW(:)) < 5
    return
end
BW = bwareafilt(BW,[5,220]);

BW = imclose(BW,strel('disk',5));
BW = imerode(BW,strel('rectangle',[4,1]));
% BW = imclose(BW,strel('disk',5));



% figure(2)
% image(BW*1000)

region = regionprops(BW,'BoundingBox');

if size(region,1) < 2
    return
end


for i = 1:size(region,1)
    area = region(i).BoundingBox(3) * region(i).BoundingBox(4);
    if ( area >= 50 && area <= 600) &&...
            ((region(i).BoundingBox(4)/region(i).BoundingBox(3)) < 1.3)&&...
            ((region(i).BoundingBox(3)/region(i).BoundingBox(4)) < 1.3)&&...
            (region(i).BoundingBox(1) >= 5) && (region(i).BoundingBox(2) >= 5)&&...
            (region(i).BoundingBox(1)+region(i).BoundingBox(3) <= 480)
%         window = CropColour(imcrop(frame,region(i).BoundingBox),[70,100,0,0,0,0]);
%         if sum(window(:)) <= 5
            coord = [coord;region(i).BoundingBox(1)+region(i).BoundingBox(3)/2,...
                region(i).BoundingBox(2)+region(i).BoundingBox(4)/2];
            figure(1)
            region(i).BoundingBox = region(i).BoundingBox + (area/90)*[-3,-3,5,5];
            rec_drawn = rectangle('Position',region(i).BoundingBox,'EdgeColor','g','LineWidth',2);
            colour_detected_rec = [colour_detected_rec;region(i).BoundingBox];
%         end
    end
end
colour_detected_rec = round(colour_detected_rec);
end
