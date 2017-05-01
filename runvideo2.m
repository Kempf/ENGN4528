close all
clear all
clc

video = VideoReader('Angry Birds In-game Trailer.avi');
video.CurrentTime = 11;
toc_0 = 0;
tic
frame_count = 1;

[eigb_red,img_ave_red] = find_eigbird_red(15);

SE = strel('rectangle',[15,15]);
win_size = [15,19,23


while true
frame = readFrame(video);
%     subplot(1,2,1)
image(frame)


frame_red_bird = CropColour(frame,[180,220,0,20,35,65]);
[frame_red_bird,region] = Filter(frame_red_bird,5,500,SE);
%     subplot(1,2,2)
%     image(frame_red_bird*1000)
%
for i = 1:size(region)
    rec = region(i).BoundingBox;
    
    for w = win_size
        
        x_list =round(rec(1)+floor(w/2):7:rec(1)+rec(3)-floor(w/2));
        y_list =round(rec(2)+floor(w/2):7:rec(2)+rec(4)-floor(w/2));
        
        for y = y_list
            for x = x_list
                frame_w = frame(x-floor(w/2):x+floor(w/2),...
                    y-floor(w/2):y+floor(w/2),:);
                dist = CalcDist_Red(frame_w);
                
            end
            
        end
        
        
    end
end

if frame_count == 10
    clc
    frame_count = 1;
    toc_1 = toc;
    time_per_frame = (toc_1 - toc_0)/10;
    frame_per_sec = round(1/time_per_frame)
    toc_0 = toc_1;
end

frame_count = frame_count + 1;
drawnow




end