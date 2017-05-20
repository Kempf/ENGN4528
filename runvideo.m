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
en_red = 1;
en_black = 1;
en_blue = 1; % ok
en_yellow = 1; % pretty good
en_white = 1; % ok
en_pig = 1; % works well
en_sling = 1; % some false matches (see blue bird loop)

% video start and end
loop = [37 40]; % black birds
% loop = [14 20]; % red birds
% loop = [15 20]; % pigs 1
% loop = [25 28]; % pigs 2
% loop = [31 36]; % pigs 3
% loop = [46 48]; % pigs 4
% loop = [22 28]; % blue bird
% loop = [12 60]; % whole video
% loop = [29 31]; % yellow
% loop = [45 48]; % white

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
frame_prev = readFrame(video);
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
    frame_py = impyramid(frame,'reduce');
    frame_r = imadjust(frame_py,[.499 0.2 0; .501 .8 1],[]);
    frame_k = imadjust(frame_py,[.499 .499 .499; .501 .501 .501],[]);
    frame_g = imadjust(frame_py,[ 0 .499 0.2; 1 .501 0.8],[]);
    frame_b = imadjust(frame_py,[ 0 0 .499; 0.7 0.5 .501],[]);
    frame_y = imadjust(frame_py,[ 0 0 0; 0.8 0.7 1],[]);
    frame_w = imadjust(frame_py,[ 0 0 0; 0.8 0.8 0.7],[]);
          
%     % color threshold objects
    frame_red_bird = CropColour(frame_r,[255,255,0,0,30,70]);
    frame_black_bird = CropColour(frame_k,[0,0,0,0,0,0]);
    frame_pig = CropColour(frame_g,[100,150,255,255,0,100]);
    frame_blue_bird = CropColour(frame_b,[100,175,255,255,255,255]);
    frame_yellow_bird = CropColour(frame_y,[255,255,255,255,20,100]);
    frame_white_bird = CropColour(frame_w,[255,255,255,255,255,255]);
    frame_slingshot = CropColour(frame,[120,190,70,160,37,100]);
%     
%     % draw frame
    figure(1)
    frame_obj = image(frame);
    hold on
%     % red birds
    if (sum(sum(frame_red_bird)) >= 1) && (en_red)
        [red_coord,rec_r,rec_drawn_r] = Filter(frame_red_bird);
    end
%     % black birds
    if (sum(sum(frame_black_bird)) >= 5) && (en_black)
        [frame_black_bird,rec_k] = Filter_Black(frame_black_bird);
    end
    % detect pigs
    if (sum(sum(frame_pig)) >= 5) && (en_pig)
        [frame_pig,region_p] = Filter_Pig(frame_pig,frame_g);

    end
    % detect blue birds
    if (sum(sum(frame_blue_bird)) >= 5) && (en_blue)
        [frame_blue_bird,rec_b] = Filter_Blue(frame_blue_bird,frame_b);

    end
    % detect yellow bird
    if (sum(sum(frame_yellow_bird)) >= 5) && (en_yellow)
        [frame_yellow_bird,rec_b] = Filter_Yellow(frame_yellow_bird);

    end
    % detect white bird
    if (sum(sum(frame_white_bird)) >= 5) && (en_white)
        [frame_white_bird,rec_b] = Filter_White(frame_white_bird,frame_w);

    end
    % detect slingshot
    if (sum(sum(frame_slingshot)) >= 5) && (en_sling)
        [sling_coordt,rec_s,rec_drawn_s] = Filter_Slingshot(frame_slingshot);
    end
%     
% 
%     
    velocity = OpticsBackground(frame_prev,frame,1)
%     
%     
    drawnow
%     frame_prev = frame;
%     delete(rec_drawn_r)
%     delete(rec_drawn_s)
%     delete(frame_obj)
%     
%     
%     
%         % fps counter
        frame_count = frame_count + 1;
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
    
    frame_prev = frame; 
    
    
end
