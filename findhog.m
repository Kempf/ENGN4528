close all
clear all
clc


frame = imread('scene1.png');
[cols_f,rows_f,~] = size(frame);
[FV,HV] = extractHOGFeatures(frame,'CellSize',[2,2],'BlockSize',[1,1]);

FV = reshape(FV,[9,length(FV)/9]);
FV = FV';


bird = imread('red_bird.png');
[c,r,~] = size(bird);
[FV1,HV1] = extractHOGFeatures(bird,'CellSize',[1,1],'BlockSize',[1,1]);
FV1 = reshape(FV1,[9,length(FV1)/9]);
FV1 = FV1';

d_frame = FV;
d_bird = FV1;
mask_size = [c,r];


d_min = inf;
d_min_2 = inf;

d_max = 0;



tic
c = 0;
for i = 1:(length(FV)-length(FV1) + 1)
    d = (d_frame(i:i+length(FV1)-1,:)-d_bird).^2;
    d = (sum(sum(d)))^0.5; 
    
    if d < d_min
        d_min_2 = d_min;
        d_min = d;
        d_min_i = i;
    end
    
    if d > d_max
        d_max = d;
    end
    
    
end






toc
 



% subplot(1,2,1)
% image(frame)
% hold on 
% plot(HV)
% 
% subplot(1,2,2)
% image(bird)
% hold on
% plot(HV1)
