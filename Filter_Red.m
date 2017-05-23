function [coord,colour_detected_rec,rec_drawn] = Filter_Red(frame_py)
%pre-process
% frame_py(:,:,1) = medfilt2(frame_py(:,:,1), [2 2]);
% frame_py(:,:,2) = medfilt2(frame_py(:,:,2), [2 2]);
% frame_py(:,:,3) = medfilt2(frame_py(:,:,3), [2 2]);


frame_ad = imadjust(frame_py,[.499 0.2 0; .501 .8 1],[]);
BW = CropColour(frame_ad,[255,255,0,0,30,70]);
coord = [];
colour_detected_rec = [];
rec_drawn = [];
if sum(BW(:)) < 5
    return
end

frame_yellow = imadjust(frame_py,[ 0.45 0.45 0.45; 0.55 0.55 0.55],[]);




SE = strel('disk',1);
BW= imclose(BW,SE);
% if possible to complete the disk
% frame_out = imdilate(frame_out,SE);
BW = bwareafilt(BW,[10,300]);
% 
% figure(2)
% image(BW*1000)

region  = regionprops(BW,'BoundingBox'); 


for i = 1:size(region,1)
    area = region(i).BoundingBox(3) * region(i).BoundingBox(4);
    if (region(i).BoundingBox(4)/region(i).BoundingBox(3)) < 1.4 &&...
            (region(i).BoundingBox(4)/region(i).BoundingBox(3))>(1/1.4) &&...
            (area < 500) && (area > 100 )

        region(i).BoundingBox = round((region(i).BoundingBox) + (area/90).*[-2,-2,4,4]);
        ic = imcrop(frame_yellow,region(i).BoundingBox);
        window = CropColour(ic,[255,255,80,255,0,170]);
%         figure(3)
%         image(ic)

        if sum(window(:)) < 6
            continue
        end

%         region(i).BoundingBox = 2*region(i).BoundingBox;
        
        coord = [coord;region(i).BoundingBox(1)+region(i).BoundingBox(3)/2,...
            region(i).BoundingBox(2)+region(i).BoundingBox(4)/2];
        figure(1)
        rec_drawn = rectangle('Position',region(i).BoundingBox,'EdgeColor','r','LineWidth',2);
%         plot(coord(:,1),coord(:,2),'r*');
        colour_detected_rec = [colour_detected_rec;region(i).BoundingBox];
    end;
end
colour_detected_rec = round(colour_detected_rec);
end
