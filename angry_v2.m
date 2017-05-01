close all
clear all
clc

video = VideoReader('Angry Birds In-game Trailer-quicktime.mov');
video.CurrentTime = 10;
toc_0 = 0;
tic
frame_count = 1;

SE = strel('rectangle',[30,30]);
fn = 1;
while hasFrame(video)

    frame = readFrame(video);
    subplot(1,2,1)
    image(frame)
    
%     [FV,HV] = extractHOGFeatures(frame,'CellSize',[1,1],'BlockSize',[1,1]);
%     hold on
% %     plot(HV)
    drawnow
% %     imwrite(frame,[num2str(fn),'.png'])
%     fn = fn + 1;
%     
    

%     %%
% %     frame(:,:,1) = medfilt2(frame(:,:,1), [10 10]);
%     frame_red_bird = CropColour(frame,[180,220,0,20,35,65]);
%     Bird_R = DetectBird(frame_red_bird,10,inf);
%     rec_R = DrawRectangle(Bird_R,'r');
% 

    frame_black_bird = CropColour(frame,[0,10,0,10,0,10]);
    frame_black_bird= imdilate(frame_black_bird,SE);
    frame_black_bird = bwareafilt(frame_black_bird,[1,inf]);

   subplot(1,2,2)
   image(frame_black_bird*1000)
    


    if frame_count == 10
        clc
        frame_count = 1;
        toc_1 = toc;
        time_per_frame = (toc_1 - toc_0)/10;
        frame_per_sec = round(1/time_per_frame)
%         title(['Frame Rate: ', num2str(frame_per_sec)])
        toc_0 = toc_1;
    end
    frame_count = frame_count + 1;
%     delete(rec_R)
end