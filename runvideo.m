close all
clear all
clc

fVid = figure('Name','Angry Birds');

% pause on click
set(fVid,'WindowButtonDownFcn',@(src,eventdata)run_pause(src,eventdata));

if ismac
    video = VideoReader('Angry Birds In-game Trailer-quicktime.mov');
    % Need this for me(Jae) to work on Macbook
    % Mac cannot read avi video
else
    video = VideoReader('Angry Birds In-game Trailer.avi');
end

clc_str = '';

% select which detection algorithms to run
en_red = 0;
en_black = 0;
en_blue = 0; % needs PCA - false matches
en_yellow = 0; % pretty good
en_white = 1; % needs PCA and thresh adjust - false matches
en_pig = 1; % works well
en_sling = 1; % some false matches (see blue bird loop)

% video start and end
% loop = [37 40]; % black birds
% loop = [14 20]; % red birds
% loop = [15 20]; % pigs 1
% loop = [25 28]; % pigs 2
% loop = [31 36]; % pigs 3
% loop = [22 28]; % blue bird
% loop = [12 60]; % whole video
% loop = [29 31]; % yellow
loop = [45 48]; % white

video.CurrentTime = loop(1);
toc_0 = 0;
tic
frame_count = 1;

% load eigenbirds
[eigb,img_ave] = find_eigbird(15);
% [eigb_black,img_ave_black] = find_eigbird_black(15);
bird_k_prev.coord = [];
bird_k_prev.init_t = [];
bird_k_prev.valid = [];

bird_r_prev.coord = [];
bird_r_prev.init_t = [];
bird_r_prev.valid = [];

while hasFrame(video)
    % video loop conditions
    if video.CurrentTime >= loop(2)
        video.CurrentTime = loop(1);
    end
    
    % exit if video window is closed
    if ~ishghandle(fVid)
        break
    end
    
    frame = readFrame(video);
    %     frame(:,:,1) = medfilt2(frame(:,:,1),[3,3]);
    %     frame(:,:,2) = medfilt2(frame(:,:,2),[3,3]);
    %     frame(:,:,3) = medfilt2(frame(:,:,3),[3,3]);
    % change contrast
    frame_r = imadjust(frame,[.499 0.2 0; .501 .8 1],[]);
    frame_k = imadjust(frame,[.499 .499 .499; .501 .501 .501],[]);
    frame_g = imadjust(frame,[ 0 .499 0.2; 1 .501 0.8],[]);
    frame_b = imadjust(frame,[ 0 0 .499; 0.7 0.8 .501],[]);
    frame_y = imadjust(frame,[ 0 0 0; 0.8 0.7 1],[]);
    frame_w = imadjust(frame,[ 0 0 0; 0.8 0.8 0.7],[]);
          
    % color threshold objects
    frame_red_bird = CropColour(frame_r,[255,255,0,0,30,70]);
    frame_black_bird = CropColour(frame_k,[0,0,0,0,0,0]);
    frame_pig = CropColour(frame_g,[100,150,255,255,0,120]);
    frame_blue_bird = CropColour(frame_b,[160,190,140,210,255,255]);
    frame_yellow_bird = CropColour(frame_y,[255,255,255,255,20,100]);
    frame_white_bird = CropColour(frame_w,[255,255,255,255,255,255]);
    frame_slingshot = CropColour(frame,[120,190,70,160,37,100]);
    
    % draw frame
    subplot(1,2,1)
    image(frame_w)
    
    % red birds
    if (sum(sum(frame_red_bird)) >= 5) && (en_red)
        subplot(1,2,2)
        image(frame_red_bird*1000)
        subplot(1,2,1)
        [frame_red_bird,rec_r] = Filter(frame_red_bird);
        bird_r = PCA_bird(frame,img_ave,eigb,rec_r,video.CurrentTime);
        bird_r = confirm_bird(bird_r,bird_r_prev,video.CurrentTime);
        bird_r_prev = bird_r;
    end
    % black birds
    if (sum(sum(frame_black_bird)) >= 5) && (en_black)
        [frame_black_bird,rec_k] = Filter_Black(frame_black_bird);
        bird_k = PCA_bird(frame,img_ave,eigb,rec_k,video.CurrentTime);
        bird_k = confirm_bird(bird_k,bird_k_prev,video.CurrentTime);
        bird_k_prev = bird_k;
    end
    % detect pigs
    if (sum(sum(frame_pig)) >= 5) && (en_pig)
        [frame_pig,region_p] = Filter_Pig(frame_pig);
        subplot(1,2,2)
        image(frame_pig*1000)
        subplot(1,2,1)
    end
    % detect blue birds
    if (sum(sum(frame_blue_bird)) >= 5) && (en_blue)
        [frame_blue_bird,rec_b] = Filter_Blue(frame_blue_bird);
        subplot(1,2,2)
        image(frame_blue_bird*1000)
        subplot(1,2,1)
    end
    % detect yellow bird
    if (sum(sum(frame_yellow_bird)) >= 5) && (en_yellow)
        [frame_yellow_bird,rec_b] = Filter_Yellow(frame_yellow_bird);
        subplot(1,2,2)
        image(frame_yellow_bird*1000)
        subplot(1,2,1)
    end
    % detect white bird
    if (sum(sum(frame_white_bird)) >= 5) && (en_white)
        [frame_white_bird,rec_b] = Filter_White(frame_white_bird);
        subplot(1,2,2)
        image(frame_white_bird*1000)
        subplot(1,2,1)
    end
    % detect slingshot
    if (sum(sum(frame_slingshot)) >= 5) && (en_sling)
        [frame_slingshot,rec_s] = Filter_Slingshot(frame_slingshot);
    end
    
    % fps counter
    if frame_count == 10
        frame_count = 1;
        toc_1 = toc;
        time_per_frame = (toc_1 - toc_0)/10;
        frame_per_sec = 1/time_per_frame;
        msg = sprintf('FPS: %.1f\n', frame_per_sec);
        fprintf([clc_str, msg]);
        clc_str = repmat(sprintf('\b'), 1, length(msg));
        toc_0 = toc_1;
    end
    
    frame_count = frame_count + 1;
    drawnow
end
