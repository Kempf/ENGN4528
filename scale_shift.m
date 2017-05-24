function [ scale_ratio,x_shift,y_shift ] = scale_shift( frame1,frame2 )

original = rgb2gray(frame1(60:320,:,:));
distorted = rgb2gray(frame2(60:320,:,:));

ptsOriginal  = detectSURFFeatures(original);
ptsDistorted = detectSURFFeatures(distorted);

[featuresOriginal,   validPtsOriginal]  = extractFeatures(original,  ptsOriginal);
[featuresDistorted, validPtsDistorted]  = extractFeatures(distorted, ptsDistorted);

indexPairs = matchFeatures(featuresOriginal, featuresDistorted);

matchedOriginal  = validPtsOriginal(indexPairs(:,1));
matchedDistorted = validPtsDistorted(indexPairs(:,2));

[tform, inlierDistorted, inlierOriginal] = estimateGeometricTransform(...
    matchedDistorted, matchedOriginal, 'similarity');

Tinv  = tform.invert.T;
ss = Tinv(2,1);
sc = Tinv(1,1);
transform=Tinv(3,1:2)
scale_recovered = sqrt(ss*ss + sc*sc)
theta_recovered = atan2(ss,sc)*180/pi;

scale_ratio=scale_recovered;
x_shift=transform(1);
y_shift=transform(2);
end

