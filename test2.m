clear all;
close all;

    frame = imread('testpig5.jpg');
    im1 = rgb2hsv(frame);
    Hc = im1(:,:,1);
    Sc = im1(:,:,2);
    imh = 360.*im1(:,:,1);
    ims = im1(:,:,2);
    
%% Testing module
    n = ((Hc>0.28) & (Hc<0.35) & (Sc>0.65) & (Sc<0.82)) | ((Hc>0.18) & (Hc<0.25) & (Sc>0.8) & (Sc<1.1));
    Hc(:,:) = 0;
    Hc(n) = 1;

    m = strel('line',20,10000);
    Hc = imclose(Hc,m);
    % grass filter
    Hc(sum(Hc,2)>400,:) = 0;
    
    Hc = bwareaopen(Hc,400);
    pigs = regionprops(Hc,'BoundingBox','Centroid'); 
    
    [n,~] = size(pigs);
    hold on
    imshow(frame)
    if n ~= 0 
        for i=1:n
            pigs_bb = pigs(i).BoundingBox;
            pigs_bc = pigs(i).Centroid; 
            rectangle('Position',pigs_bb,'EdgeColor','g','LineWidth',2); 
            drawnow update
        end
    end
    
    hold off
%%
        figure;
    imshow(Hc);