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
    

    drawnow

    frame_red_bird = CropColour(frame,[180,220,0,20,35,65]);





   subplot(1,2,2)
   image(frame_red_bird*1000)
    


    if frame_count == 10
        clc
        frame_count = 1;
        toc_1 = toc;
        time_per_frame = (toc_1 - toc_0)/10;
        frame_per_sec = round(1/time_per_frame)
        toc_0 = toc_1;
    end
    frame_count = frame_count + 1;

end
