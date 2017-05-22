function [coord,colour_detected_rec,rec_drawn] = Filter_White(frame_py)
%pre-process
frame_ad = imadjust(frame_py,[ 0 0 0; 0.8 0.8 0.7],[]);
frame = CropColour(frame_ad,[255,255,255,255,255,255]);

SE = strel('rectangle',[3 3]);
%frame_out = imclose(frame,SE);
frame = imopen(frame,SE);
BW = bwareafilt(frame,[40,120]);

region = regionprops(BW,'BoundingBox');
coord = [];
colour_detected_rec = [];
rec_drawn = [];

for i = 1:size(region,1)
    area = region(i).BoundingBox(3) * region(i).BoundingBox(4);
    if (area <= 250) && (area >= 25) &&...
            ((region(i).BoundingBox(4)/region(i).BoundingBox(3)) < 1.9)&&...
            ((region(i).BoundingBox(3)/region(i).BoundingBox(4)) < 1.9)&&...
            (region(i).BoundingBox(1) >= 2) && (region(i).BoundingBox(2) >= 2)&&...
            (region(i).BoundingBox(2) <= 105)&&...
            (region(i).BoundingBox(1)+region(i).BoundingBox(3) <= 385)
        window = CropColour(imcrop(frame_py,region(i).BoundingBox),[255,255,200,250,100,190]);
        if sum(window(:)) >= 5
            region(i).BoundingBox = 2*(region(i).BoundingBox);%+ [-3,-13,5,15];
        coord = [coord;region(i).BoundingBox(1)+region(i).BoundingBox(3)/2,...
            region(i).BoundingBox(2)+region(i).BoundingBox(4)/2];
            figure(1)
            rec_drawn = rectangle('Position',region(i).BoundingBox,'EdgeColor','b','LineWidth',2);
            plot(coord(:,1),coord(:,2),'r*');
            colour_detected_rec = [colour_detected_rec;region(i).BoundingBox];
        end;
    end;
end;
colour_detected_rec = round(colour_detected_rec);
end