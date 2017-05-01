function [bird] = DetectBird(frame,LB,UB)
    frame = bwareafilt(frame,[LB,UB]);
    SE = strel('rectangle',[5,5]);
    frame = imdilate(frame,SE);
    bird = regionprops(frame,'BoundingBox','Centroid');

    
end
