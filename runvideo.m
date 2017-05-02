close all
clear all
clc

if ismac
    video = VideoReader('Angry Birds In-game Trailer-quicktime.mov');
else
    video = VideoReader('Angry Birds In-game Trailer.avi');
end


video.CurrentTime = 11;
toc_0 = 0;
tic
frame_count = 1;

[eigb_red,img_ave_red] = find_eigbird_red(15);


win_size = [19,21];
    


while hasFrame(video)


frame = readFrame(video);
    subplot(1,2,1)
image(frame)


frame_red_bird = CropColour(frame,[190,210,0,20,35,65]);
[frame_red_bird,region] = Filter(frame_red_bird,1,500);
    subplot(1,2,2)
    image(frame_red_bird*1000)
%

% for i = 1:size(region)
%     rec = region(i).BoundingBox;
%     bird_found = 0;
%     for w = win_size
%         
%         x_list =round(rec(1)+floor(w/2):5:rec(1)+rec(3)-floor(w/2));
%         y_list =round(rec(2)+floor(w/2):5:rec(2)+rec(4)-floor(w/2));
%         
%         for y = y_list
%             for x = x_list
%                 
% %                 x
% %                 y
%                 frame_w = frame(y-floor(w/2):y+floor(w/2),...
%                     x-floor(w/2):x+floor(w/2),:);
% %                 subplot(1,2,2)
% %                 image(frame_w)
% %                 pause(0.5)
%                 dist = CalcDist_Red(frame_w,img_ave_red,eigb_red);
% 
%                 if dist <= 1.4
%                     bird_found = 1;
%                     rec_bird = rectangle('Position',[x-floor(w/2),y-floor(w/2),w,w]);
%                     break
%                 end
%                 
%             end
%             if bird_found
%                 break
%             end
%         end
%         if bird_found
%             break
%         end
%         
%     end
% end

if frame_count == 10
    clc
    frame_count = 1;
    toc_1 = toc;
    time_per_frame = (toc_1 - toc_0)/10;
    frame_per_sec = 1/time_per_frame
    toc_0 = toc_1;
end

frame_count = frame_count + 1;
drawnow
end
