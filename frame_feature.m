function []=frame_feature(frame1,frame2)
I1 = rgb2gray(frame1);
I2 = rgb2gray(frame2);

% points1 = detectHarrisFeatures(I1);
% points2 = detectHarrisFeatures(I2);

points1 = detectSURFFeatures(I1);
points2 = detectSURFFeatures(I2);


[features1,valid_points1] = extractFeatures(I1,points1);
[features2,valid_points2] = extractFeatures(I2,points2);

indexPairs = matchFeatures(features1,features2);

matchedPoints1 = valid_points1(indexPairs(:,1),:);
matchedPoints2 = valid_points2(indexPairs(:,2),:);

figure(2); showMatchedFeatures(I1,I2,matchedPoints1,matchedPoints2);
legend('matched points 1','matched points 2');

end