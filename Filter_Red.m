function [coord,colour_detected_rec,rec_drawn] = Filter_Red(frame_py)
%pre-process
frame_ad = imadjust(frame_py,[.499 0.2 0; .501 .8 1],[]);
frame = CropColour(frame_ad,[255,255,0,0,30,70]);

SE = strel('rectangle',[3,3]);
frame = imclose(frame,SE);
% if possible to complete the disk
% frame_out = imdilate(frame_out,SE);
BW = bwareafilt(frame,[10,200]);

region  = regionprops(BW,'BoundingBox');
coord = [];
colour_detected_rec = [];
rec_drawn = [];

for i = 1:size(region,1)
    if (region(i).BoundingBox(4)/region(i).BoundingBox(3)) < 1.8 &&...
            (region(i).BoundingBox(4)/region(i).BoundingBox(3))>0.6
        region(i).BoundingBox = 2*(region(i).BoundingBox);% + [-5,-3,8,6])
        coord = [coord;region(i).BoundingBox(1)+region(i).BoundingBox(3)/2,...
            region(i).BoundingBox(2)+region(i).BoundingBox(4)/2];
        figure(1)
        rec_drawn = rectangle('Position',region(i).BoundingBox,'EdgeColor','r','LineWidth',2);
        plot(coord(:,1),coord(:,2),'r*');
        colour_detected_rec = [colour_detected_rec;region(i).BoundingBox];
    end;
end
colour_detected_rec = round(colour_detected_rec);
end