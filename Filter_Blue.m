function [coord,colour_detected_rec,rec_drawn] = Filter_Blue(frame_py)
%pre-process
frame_ad = imadjust(frame_py,[ 0 0 .499; 0.7 0.5 .501],[]);
frame = CropColour(frame_ad,[100,175,255,255,255,255]);

SE = strel('rectangle',[4,4]);
frame = imclose(frame,SE);
BW = bwareafilt(frame,[5,200]);

region  = regionprops(BW,'BoundingBox');
coord = [];
colour_detected_rec = [];
rec_drawn = [];

for i = 1:size(region,1)
    %area = region(i).BoundingBox(3)*region(i).BoundingBox(4);
    %region(i).BoundingBox = region(i).BoundingBox + [-5,-3,10,5];
    
%     if (area <= 200) && (area >= 18) &&...
%             ((region(i).BoundingBox(4)/region(i).BoundingBox(3)) < 1.8)&&...
%             ((region(i).BoundingBox(3)/region(i).BoundingBox(4)) < 1.8)&&...
%             (region(i).BoundingBox(1) >= 5) && (region(i).BoundingBox(2) >= 30)
            
        % second color filter
        if (region(i).BoundingBox(4)/region(i).BoundingBox(3)) < 1.8 &&...
            (region(i).BoundingBox(4)/region(i).BoundingBox(3))>0.6
            window = CropColour(imcrop(frame_ad,region(i).BoundingBox),[200,255,120,255,0,0]);
            if sum(window(:)) >= 1
                %region(i).BoundingBox = region(i).BoundingBox +[-3,-3,5,5]; 
                region(i).BoundingBox = 2*(region(i).BoundingBox);% + [-3,-3,5,5];
                coord = [coord;region(i).BoundingBox(1)+region(i).BoundingBox(3)/2,...
                region(i).BoundingBox(2)+region(i).BoundingBox(4)/2];
            figure(1)
                rec = rectangle('Position',region(i).BoundingBox,'EdgeColor','b','LineWidth',2);
                plot(coord(:,1),coord(:,2),'r*');
                colour_detected_rec = [colour_detected_rec;region(i).BoundingBox];
            end;
%         end
        end
end

colour_detected_rec = round(colour_detected_rec);

end