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
en_blue = 1;
en_yellow = 1;
en_white = 1;
en_pig = 1;
en_sling = 1; 

% video start and end
 loop = [12 60]; % whole video
% loop = [14 20]; % red birds
% loop = [22 28]; % blue birds
% loop = [29 31]; % yellow birds
% loop = [37 40]; % black birds
% loop = [45 48]; % white bird
% loop = [15 20]; % pigs 1
% loop = [25 28]; % pigs 2
% loop = [31 36]; % pigs 3
% loop = [46 48]; % pigs 4

video.CurrentTime = loop(1);
toc_0 = 0;
tic
frame_count = 1;

<<<<<<< HEAD
frame_prev = readFrame(video);

%jrajectory
coord_store = NaN(2,3);
para_traj = NaN(1,3);

=======
% load eigenbirds
[eigb,img_ave] = find_eigbird(15);
% [eigb_black,img_ave_black] = find_eigbird_black(15);
% bird_k_prev.coord = [];
% bird_k_prev.init_t = [];
% bird_k_prev.valid = [];
% bird_k_prev.status = [];
% 
% bird_r_prev.coord = [];
% bird_r_prev.init_t = [];
% bird_r_prev.valid = [];
% bird_r_prev.status = [];
frame_prev = readFrame(video); 
coord_store = NaN(2,3); % store the coordinates to sketch the parabolic curves
para_traj = NaN(1,3); % parabolic trajectory of each frame
init_trajectory = NaN(1,3); % initialized trajectory( trajectory used to calculate the world coordnates)
init_frame = NaN; % the frame which the bird is launched
frame_number = 1; % current frame number
Vx = NaN; % velocity in x direction
world_coord = [NaN,NaN]; %world coordnate system
>>>>>>> refs/remotes/origin/master
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

%    % scale frame by 1/2 in order to process quicker
    frame_py = impyramid(frame,'reduce');
%     frame_r = imadjust(frame_py,[.499 0.2 0; .501 .8 1],[]);
%     frame_k = imadjust(frame_py,[.499 .499 .499; .501 .501 .501],[]);
%     frame_g = imadjust(frame_py,[ 0 .499 0.2; 1 .501 0.8],[]);
%     frame_b = imadjust(frame_py,[ 0 0 .499; 0.7 0.5 .501],[]);
%     frame_y = imadjust(frame_py,[ 0 0 0; 0.8 0.7 1],[]);
%     frame_w = imadjust(frame_py,[ 0 0 0; 0.8 0.8 0.7],[]);
          
%     % color threshold objects
%     frame_red_bird = CropColour(frame_r,[255,255,0,0,30,70]);
%     frame_blue_bird = CropColour(frame_b,[100,175,255,255,255,255]);
%     frame_black_bird = CropColour(frame_k,[0,0,0,0,0,0]);
%     frame_pig = CropColour(frame_g,[100,150,255,255,0,100]);
%     frame_yellow_bird = CropColour(frame_y,[255,255,255,255,20,100]);
%     frame_white_bird = CropColour(frame_w,[255,255,255,255,255,255]);
%     frame_slingshot = CropColour(frame,[120,190,70,160,37,100]);
%     
    figure(1)
%     % draw frame
    frame_obj = image(frame);
    hold on
    
    % detect slingshot
    if en_sling
        [sling_coordt,rec_s,rec_drawn_s] = Filter_Slingshot(frame_py);
    end
    
%     % detect red birds
    if  en_red
        [red_coord,rec_r,rec_drawn_r] = Filter_Red(frame_py);
    end
    
%     % detect blue birds
    if en_blue
        [blue_coord,rec_b,rec_drawn_b] = Filter_Blue(frame_py);
    end
    
    % detect yellow bird
    if en_yellow
        [yellow_coord,rec_y,rec_drawn_y] = Filter_Yellow(frame_py);
    end
    
%     % black birds
    if en_black
        [black_coord,rec_k,rec_drawn_k] = Filter_Black(frame_py);
    end
    
    %no detection 
    % detect white bird
    if en_white
        [white_coord,rec_w,rec_drawn_w] = Filter_White(frame_py);
    end
    
%    % detect pigs
    if en_pig
        [pig_coord,rec_g,rec_drawn_g] = Filter_Pig(frame_py);
    end
%     
%   
%     
     velocity = OpticsBackground(frame_prev,frame,1);
%     
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
    
    frame_number = frame_number + 1;
    
end