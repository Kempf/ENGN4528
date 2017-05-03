function [frame_out,region] = Filter_Black(frame)
    
    SE = strel('rectangle',[5,5]);
    
    frame= imdilate(frame,SE);
    frame = bwareafilt(frame,[300,1000]);
    region = regionprops(frame,'BoundingBox');
    
    if size(region,1) < 8

        for i = 1:size(region,1)
            area = region(i).BoundingBox(3) * region(i).BoundingBox(4);
            if (area <= 1000) && (area >= 100) &&(region(i).BoundingBox(3)<50)...
                    &&(region(i).BoundingBox(4)<50)...
                    &&((region(i).BoundingBox(4)/region(i).BoundingBox(3)) < 1.4)...
                    &&((region(i).BoundingBox(3)/region(i).BoundingBox(4)) < 1.4)
                region(i).BoundingBox = region(i).BoundingBox + [-3,-3,5,5];
                
                rec = rectangle('Position',region(i).BoundingBox,'EdgeColor','k','LineWidth',4);
%             else
%                 clc
%                 disp('No Rectangle')
%                 fprintf('AREA: %d \n',area)
%                 fprintf('x width: %d \n',region(i).BoundingBox(3))
%                 fprintf('y width: %d \n',region(i).BoundingBox(4))
%                 fprintf('y/x: %.3f \n',region(i).BoundingBox(4)/region(i).BoundingBox(3))
%                 fprintf('x/y: %.3f \n',region(i).BoundingBox(3)/region(i).BoundingBox(4))
%                 pause(2)
            end
        
        end
    end
    
    frame_out = frame;


end