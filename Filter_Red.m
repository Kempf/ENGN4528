function [coord,colour_detected_rec,rec_drawn] = Filter_Red(frame)

frame_ad = imadjust(frame,[.499 0.2 0; .501 .8 1],[]);


%apply contrast to distriminate all the non-red pixels and 
%obtain a binary image of red-pixels using the pre-defined function
BW = CropColour(frame_ad,[255,255,0,0,30,70]);


coord = [];
colour_detected_rec = [];
rec_drawn = [];

%if the number of found red pixels are less than 5,
%assume that there is no red bird in the frame.
if sum(BW(:)) < 5
    return
end


frame_yellow = imadjust(frame,[ 0.45 0.45 0.45; 0.55 0.55 0.55],[]);
%do the sampe process as the above but as the yellow.
%this is for detecting the yellow beaks of the bird

SE = strel('disk',1);
BW= imclose(BW,SE);
BW = bwareafilt(BW,[10,300]);
% apply mophology to the binary image
% and this will help to enclose the whole 
% body of found birds with a rectangle.

region  = regionprops(BW,'BoundingBox'); 
%Obtain the bounding boxes of the result above.

for i = 1:size(region,1)
    area = region(i).BoundingBox(3) * region(i).BoundingBox(4);
    if (area < 500) && (area > 30 )
       %Discard the rectangles that are too large or small.
        region(i).BoundingBox = (region(i).BoundingBox) + (area/90).*[-2,-2,4,6]        
        coord = [coord;region(i).BoundingBox(1)+region(i).BoundingBox(3)/2,...
            region(i).BoundingBox(2)+region(i).BoundingBox(4)/2];
        figure(1)
        rec_drawn = rectangle('Position',region(i).BoundingBox,'EdgeColor','r','LineWidth',2);
        colour_detected_rec = [colour_detected_rec;region(i).BoundingBox];
    end;
end
colour_detected_rec = round(colour_detected_rec);
end
