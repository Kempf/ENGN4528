function [frame_out,region] = Filter(frame,LB,UB)
%LB: lower boundary
%UB: upper boundary

%only takes the pixel clusters that are within this threshold
frame_out = bwareafilt(frame,[LB,UB]);
SE = strel('rectangle',[10,5]);
frame_out = imclose(frame_out,SE);
SE = strel('rectangle',[10,1]);
frame_out = imdilate(frame_out,SE);
region  = regionprops(frame_out,'BoundingBox');


% if size(region,1) ~= 0
%     for i = 1:size(region,1)
%         
%         rec = rectangle('Position',region(i).BoundingBox,'EdgeColor','r','LineWidth',2);
%         
%     end
% end
end