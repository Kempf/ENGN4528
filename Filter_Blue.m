function [coord,colour_detected_rec,rec_drawn] = Filter_Blue(frame_py)
%pre-process
frame_ad = imadjust(frame_py,[ 0 0 .499; 0.7 0.5 .501],[]);
frame = CropColour(frame_ad,[100,175,255,255,255,255]);

frame = imclose(frame,strel('rectangle',[6,6]));
%frame = imclose(frame,strel('rectangle',[9,1]));
%frame = imdilate(frame,);
%frame = imerode(frame,strel('rectangle',[1,2]));
%frame = imerode(frame,strel('rectangle',[2,1]));

BW = bwareafilt(frame,[5,150]);
SE = strel('disk',2);
BW= imclose(BW,SE);

% subplot(1,2,2);
% image(BW*1000);
% subplot(1,2,1);

region  = regionprops(BW,'BoundingBox');
coord = [];
colour_detected_rec = [];
rec_drawn = [];

for i = 1:size(region,1)
    area = region(i).BoundingBox(3)*region(i).BoundingBox(4);
    if (region(i).BoundingBox(4)/region(i).BoundingBox(3)) < 1.8 &&...
        (region(i).BoundingBox(4)/region(i).BoundingBox(3))>0.6 &&...
        (region(i).BoundingBox(2) >= 60) && (region(i).BoundingBox(2) <= 270)
        
        beakpos = region(i).BoundingBox +[2,2,-2,-2];
        % get rid of negatives
        for b = 1:4
            if beakpos(b) <= 0
                beakpos(b) = 1;
            end
        end
        region(i).BoundingBox = region(i).BoundingBox +[-2,-2,5,5]; 
        window = CropColour(imcrop(frame_py,beakpos),[180,255,150,200,30,100]);
        window = window + CropColour(imcrop(frame_py,beakpos),[120,255,185,200,100,160]);
        
        %rectangle('Position',beakpos,'EdgeColor','c','LineWidth',2);
        if sum(window(:)) >= 2
            coord = [coord;region(i).BoundingBox(1)+region(i).BoundingBox(3)/2,...
            region(i).BoundingBox(2)+region(i).BoundingBox(4)/2,0,2];
            figure(1)
            rec = rectangle('Position',region(i).BoundingBox,'EdgeColor','b','LineWidth',2);
            colour_detected_rec = [colour_detected_rec;region(i).BoundingBox];
        end;
    end
end

colour_detected_rec = round(colour_detected_rec);

end
