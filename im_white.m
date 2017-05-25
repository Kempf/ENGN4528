function [coord] = im_white(frame)
coord=[];
frame_ad = imadjust(frame,[0 0 0; 0.8 0.8 0.7]);
frame=CropColour(frame_ad,[255 255 255 255 255 255]);
cc=imdilate(frame,strel('diamond',3));
BW=bwareafilt(cc,[100,1000]);
region=regionprops(BW,'BoundingBox');
for i = 1 : size(region,1)
    if region(i).BoundingBox(1)<310 && region(i).BoundingBox(1)>50&&...
            region(i).BoundingBox(2)<110
        rec=rectangle('Position',region(i).BoundingBox,'EdgeColor','w','LineWidth',2);
        coord=[coord;region(i).BoundingBox(1)+region(i).BoundingBox(3)/2,...
            region(i).BoundingBox(2)+region(i).BoundingBox(4)/2];
    end;
end;
end