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
loop = [14 20]; % red birds
% %loop = [15 20]; % pigs 1
% loop = [25 28]; % pigs 2
%loop = [31 36]; % pigs 3
% loop = [22,28];

% loop = [1,60];
video.CurrentTime = loop(1);
toc_0 = 0;
tic
frame_count = 1;

[eigb,img_ave] = find_eigbird(15);
% [eigb_black,img_ave_black] = find_eigbird_black(15);
bird_k_prev.coord = [];
bird_k_prev.init_t = [];
bird_k_prev.valid = [];

bird_r_prev.coord = [];
bird_r_prev.init_t = [];
bird_r_prev.valid = [];


while hasFrame(video)
    if video.CurrentTime >= loop(2)
        video.CurrentTime = loop(1);
    end
    
    if ~ishghandle(fVid)
        break
    end
    
    
    frame = readFrame(video);
    %     frame(:,:,1) = medfilt2(frame(:,:,1),[3,3]);
    %     frame(:,:,2) = medfilt2(frame(:,:,2),[3,3]);
    %     frame(:,:,3) = medfilt2(frame(:,:,3),[3,3]);
    frame_r = imadjust(frame,[.499 0.2 0; .501 .8 1],[]);
    frame_k = imadjust(frame,[.499 .499 .499; .501 .501 .501],[]);
    
    
    
    
   
    frame_red_bird = CropColour(frame_r,[255,255,0,0,30,70]);
    frame_black_bird = CropColour(frame_k,[0,0,0,0,0,0]);
    frame_pig = CropColour(frame,[100,150,200,230,30,90]);
    frame_blue_bird = CropColour(frame,[90,140,120,170,160,200]);
    frame_yellow_brid = CropColour(frame,[90,140,120,170,160,200]);
    frame_slingshot = CropColour(frame,[120,190,70,160,37,100]);
    
     
    
    if sum(sum(frame_red_bird)) >= 5
        [frame_red_bird,rec_r] = Filter(frame_red_bird);
        subplot(1,2,1)
    image(frame_red_bird*1000)
        bird_r = PCA_bird(frame,img_ave,eigb,rec_r,video.CurrentTime);
        bird_r = confirm_bird(bird_r,bird_r_prev,video.CurrentTime);
        bird_r_prev = bird_r;
        
    end
    if sum(sum(frame_black_bird)) >= 5
        [frame_black_bird,rec_k] = Filter_Black(frame_black_bird);
        bird_k = PCA_bird(frame,img_ave,eigb,rec_k,video.CurrentTime);
        bird_k = confirm_bird(bird_k,bird_k_prev,video.CurrentTime);
        bird_k_prev = bird_k;
        
        
        
        
    end
    %     if sum(sum(frame_pig)) >= 5
    %         [frame_pig,region_p] = Filter_Pig(frame_pig);
    %     end
    %     if sum(sum(frame_blue_bird)) >= 5
    %         [frame_blue_bird,rec_b] = Filter_Blue(frame_blue_bird);
    %     end
    %
    %     if sum(sum(frame_slingshot)) >= 5
    %         [frame_slingshot,rec_s] = Filter_Slingshot(frame_slingshot);
    %     end
    %
    
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
