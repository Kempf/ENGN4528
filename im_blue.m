function [coord] =im_blue(frame)
coord=[];
cc=CropColour(rgb2hsv(frame),[0.1,0.4,0,1,0,1]);
cc=imdilate(cc,strel('diamond',3));
%figure(2);imshow(cc);
BW=bwareafilt(cc,[50,400]);
%figure(3);imshow(BW);

region = regionprops(BW,'BoundingBox');
for i = 1 : size(region,1)
    if region(i).BoundingBox(1)<240 && region(i).BoundingBox(2)<220
        rec=rectangle('Position',region(i).BoundingBox,'EdgeColor','b','LineWidth',2);
        coord=[coord;region(i).BoundingBox(1)+region(i).BoundingBox(3)/2,...
            region(i).BoundingBox(2)+region(i).BoundingBox(4)/2];
    end;
end;
