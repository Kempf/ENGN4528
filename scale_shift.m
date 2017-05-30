function [ tform ] = scale_shift( frame1,frame2 )

original = rgb2gray(frame1(60:end,:,:));
distorted = rgb2gray(frame2(60:end,:,:));

ptsOriginal  = detectSURFFeatures(original);
ptsDistorted = detectSURFFeatures(distorted);

[featuresOriginal,   validPtsOriginal]  = extractFeatures(original,  ptsOriginal);
[featuresDistorted, validPtsDistorted]  = extractFeatures(distorted, ptsDistorted);

indexPairs = matchFeatures(featuresOriginal, featuresDistorted);

matchedOriginal  = validPtsOriginal(indexPairs(:,1));
matchedDistorted = validPtsDistorted(indexPairs(:,2));

[tform, ~] = estimateGeometricTransform(...
    matchedOriginal, matchedDistorted, 'similarity');

Tinv  = tform.invert.T;
tform=inv(Tinv);
end

