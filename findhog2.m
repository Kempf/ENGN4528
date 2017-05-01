clear all
close all
clc


video = VideoReader('Angry Birds In-game Trailer.avi');
video.CurrentTime = 12.3;


frame = readFrame(video);

bird = imread('red_bird.png');
bird_2 = imread('red_bird_2.png');
image(frame)


binsize = 360;
[d_f,HV_f] = extractHOGFeatures(frame,'CellSize',[20,16],'BlockSize',[1,1],...
    'NumBins',binsize);
[d_b,HV_b] = extractHOGFeatures(bird,'CellSize',[20,16],'BlockSize',[1,1],...
     'NumBins',binsize);
 
 
hold on
plot(HV_f)
 
 
 
d_b = reshape(d_b,[binsize,length(d_b)/binsize]);
d_b = d_b';

d_b=(d_b > 0.1).*d_b;

d_f = reshape(d_f,[binsize,length(d_f)/binsize]);
d_f = d_f';
d_f=(d_f > 0.1).*d_f;



% i = 42
% [col_b,~,~] = size(bird);
% x = floor(i/col_b)+1;
% y = mod(42,col_b)


d_min = inf;
d_min_2 = inf;


tic
[col_f,~,~] = size(frame);
for i = 1:(length(d_f)-length(d_b) + 1)

    
    d = (d_f(i:i+size(d_b,1)-1,:)-d_b).^2;
    d = (sum(d,2)).^0.5; 
    d = sum(d);

    if d < d_min
        d_min_2 = d_min;
        d_min = d;
        d_min_i = i;
        x = floor(i/col_f)+1;
        y = mod(i,col_f)+1;
%         plot(x,y,'ro')
%         drawnow
        
    end
    
    if d_min < 0.4*d_min_2
        m = d_min;
        m_i = i;
    end
    
    
    
      
end
toc


% 
% 
% 
% 
% 
% 
