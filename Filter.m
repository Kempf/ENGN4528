function [coord,colour_detected_rec,rec_drawn] = Filter(frame)

%only takes the pixel clusters that are within this threshold

% SE = strel('rectangle',[2,2]);
% frame_out = imopen(frame,SE);
% SE = strel('disk',3);
SE = strel('rectangle',[3,3]);

frame_out = imclose(frame,SE);
frame_out = bwareafilt(frame_out,[10,500]);


% frame_out = imdilate(frame_out,SE);
region  = regionprops(frame_out,'BoundingBox');
colour_detected_rec = [];
coord = [];
rec_drawn = [];

for i = 1:size(region,1)
       area = region(i).BoundingBox(3) * region(i).BoundingBox(4);
%     if (area <= 1000) && (area >= 10) 
% %             ((region(i).BoundingBox(4)/region(i).BoundingBox(3)) < 1.4)&&...
% %             ((region(i).BoundingBox(3)/region(i).BoundingBox(4)) < 1.4)
% %             (region(i).BoundingBox(1) >= 10) && (region(i).BoundingBox(2) >= 10)&&...
% %             (region(i).BoundingBox(1)+region(i).BoundingBox(3) <= 470)
        
        region(i).BoundingBox = 2*(region(i).BoundingBox + [-5,-3,8,6]);
        coord = [coord;region(i).BoundingBox(1)+region(i).BoundingBox(3)/2,...
            region(i).BoundingBox(2)+region(i).BoundingBox(4)/2];
        figure(1)
        rec_drawn = rectangle('Position',region(i).BoundingBox,'EdgeColor','r','LineWidth',2);
        plot(coord(:,1),coord(:,2),'r*')
        colour_detected_rec = [colour_detected_rec;region(i).BoundingBox];
%     else
%         region(i).BondingBox = 0;
%     end
    
end


colour_detected_rec = 2*round(colour_detected_rec);


end