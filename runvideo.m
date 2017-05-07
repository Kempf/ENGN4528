close all
clear all
clc

fVid = figure('Name','Angry Birds');

if ismac
    video = VideoReader('Angry Birds In-game Trailer-quicktime.mov');
    % Need this for me(Jae) to work on Macbook
    % Mac cannot read avi video
else
    video = VideoReader('Angry Birds In-game Trailer.avi');
end

% video start and end
% loop = [37 40]; % black birds
% loop = [12 18]; % red birds
% %loop = [15 20]; % pigs 1
% loop = [25 28]; % pigs 2 
%loop = [31 36]; % pigs 3
%loop = [54,60]; % ?
%loop = [29 32]; % yellow
loop = [22 27]; % blue

video.CurrentTime = loop(1);
toc_0 = 0;
tic
frame_count = 1;

[eigb_red,img_ave_red] = find_eigbird_red(15);
[eigb_black,img_ave_black] = find_eigbird_black(15);




% pause(3)


while hasFrame(video)
    if video.CurrentTime >= loop(2)
        video.CurrentTime = loop(1);
    end
    
    if ~ishghandle(fVid)
        break
    end
    
    frame = readFrame(video);
    
%     subplot(1,2,1)
    image(frame)
    %%
    frame_med(:,:,1) = medfilt2(frame(:,:,1),[3,3]);
    frame_med(:,:,2) = medfilt2(frame(:,:,2),[3,3]);
    frame_med(:,:,3) = medfilt2(frame(:,:,3),[3,3]);
    
    
    frame_red_bird = CropColour(frame_med,[140,220,0,30,30,70]);
    frame_black_bird = CropColour(frame_med,[0,30,0,30,0,30]);
    frame_pig = CropColour(frame_med,[100,150,200,230,30,90]);
    frame_yellow = CropColour(frame_med,[200,255,200,255,30,150]);
    frame_blue = CropColour(frame_med,[90,160,100,200,100,190]);
    
    if sum(sum(frame_red_bird)) >= 5
        [frame_red_bird,rec_r] = Filter(frame_red_bird);
        coord_r = confirm_red_bird(frame,img_ave_red,eigb_red,rec_r);
    end
    

    if sum(sum(frame_black_bird)) >= 5
        [frame_black_bird,rec_k] = Filter_Black(frame_black_bird);
        coord_k = confirm_black_bird(frame,img_ave_black,eigb_black,rec_k);
    end
    
    if sum(sum(frame_pig)) >= 5
        [frame_pig,region_p] = Filter_Pig(frame_pig);
    end  
    
    if sum(sum(frame_yellow)) >= 5
        [frame_yellow,region_y] = Filter_Yellow(frame_yellow);
    end  
    
    if sum(sum(frame_blue)) >= 5
        [frame_blue,region_b] = Filter_Blue(frame_blue);
    end 
    
%     subplot(1,2,2)
%     image(frame_pig*1000)
%     %
    
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
