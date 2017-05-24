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
% loop = [12 60]; % whole video
% loop = [14 20]; % red birds
% loop = [22 28]; % blue birds
% loop = [29 32]; % yellow birds
loop = [37 40]; % black birds
% loop = [45 48]; % white bird
% loop = [15 20]; % pigs 1
% loop = [25 28]; % pigs 2
% loop = [31 36]; % pigs 3
% loop = [46 48]; % pigs 4

% detection control
%              pig 	  red	  	blue   	 yellow   black   white
det_time = [ [14; 60] [12; 24] [21; 28] [28; 34] [37; 41] [37; 49]];
det_cont = [det_time; en_pig en_red en_blue en_yellow en_black en_white;...
    zeros(1,6)];
sling = [12 15; 22 24; 28 30; 37 38; 45 47; 56 57];

video.CurrentTime = loop(1);
toc_0 = 0;
tic
frame_count = 1;

frame_prev = readFrame(video);

%trajectory
coord_store = NaN(2,3);
para_traj = NaN(1,3);

frame_prev = readFrame(video);
coord_store = NaN(2,3); % store the coordinates to sketch the parabolic curves
para_traj = NaN(1,3); % parabolic trajectory of each frame
init_trajectory = NaN(1,3); % initialized trajectory( trajectory used to calculate the world coordnates)
init_frame = NaN; % the frame which the bird is launched

Vx = NaN; % velocity in x direction
world_coord = [NaN,NaN]; %world coordnate system
Data = NaN(6,4);

red_coord = [];
blue_coord = [];
black_coord = [];
yellow_coord = [];
white_coord = [];

bird_loaded_coord = [];


bird_pixel_prev = [];



whiteout_time = 0;
background_displacement = [0,0];
sling_recorded = 0;
scale = 1;
while hasFrame(video)
    
    % video loop conditions
    if video.CurrentTime >= loop(2)
        video.CurrentTime = loop(1);
    end
    
    for k=1:6
        if(video.CurrentTime >= det_cont(1,k) &&...
                video.CurrentTime <= det_cont(2,k) &&...
                det_cont(3,k))
            
            det_cont(4,k) = 1;
        else
            det_cont(4,k) = 0;
        end
    end
    
    sling_det = zeros(size(sling,1),1);
    for k=1:size(sling,1)
        if(video.CurrentTime >= sling(k,1) &&...
                video.CurrentTime <= sling(k,2))
            
            sling_det(k) = 1;
        end
    end
    if(any(sling_det))
        en_sling = 1;
    else
        en_sling = 0;
    end
    
    en_pig = det_cont(4,1);
    en_red = det_cont(4,2);
    en_blue = det_cont(4,3);
    en_yellow = det_cont(4,4);
    en_black = det_cont(4,5);
    en_white = det_cont(4,6);
    
    % exit if video window is closed
    if ~ishghandle(fVid)
        break
    end
    
    frame = readFrame(video);
    
    %    % scale frame by 1/2 in order to process quicker
    %
    figure(1)
    %     % draw frame
    frame_obj = image(frame);
    
    
    % detect slingshot
    if en_sling
        [sling_coord,rec_drawn_s] = Filter_Slingshot(frame);
    else
        sling_coord = [];
    end
    
    %     % detect red birds
    if  en_red
        [red_coord,rec_r,rec_drawn_r] = Filter_Red(frame);
    else
        red_coord = [];
    end
    
    %     % detect blue birds
    %     if en_blue
    %         [blue_coord,rec_b,rec_drawn_b] = Filter_Blue(frame_py);
    %     end
    
    % detect yellow bird
    if en_yellow
        [yellow_coord,rec_y,rec_drawn_y] = Filter_Yellow(frame);
    else
        yellow_coord = [];
    end
    
    %     % black birds
    if en_black
        [black_coord,rec_k,rec_drawn_k] = Filter_Black(frame);
    else
        black_coord = [];
    end
    
    % detect white bird
    if en_white
        [white_coord,rec_w,rec_drawn_w] = Filter_White(frame);
    else
        white_coord = [];
    end
    
    %    % detect pigs
    if en_pig
        [pig_coord,rec_g,rec_drawn_g] = Filter_Pig(frame);
    else
        pig_coord = [];
    end
    
    bird_pixel =[red_coord;blue_coord;black_coord;yellow_coord;white_coord];
    
    
    
    
    
    if isequal(frame,255*ones(320,480,3))
        whiteout_time = video.CurrentTime;
        en_sift = 0;
        sling_recorded = 0;
        scale = 1;
        background_displacement  = [0,0];
    end
    
    if video.CurrentTime > whiteout_time + 1
        en_sift = 1;
        whiteout_time = 0;
    end
    
    if en_sift == 1;
        [ scale_ratio,x_shift,y_shift,~ ] = scale_shift(frame_prev,frame);
        x_shift = round(x_shift);
        y_shift = round(y_shift);
        if sling_recorded == 1;
            scale = scale*(1/scale_ratio);
            x_shift_scaled = round(x_shift/scale);
            y_shift_scaled = round(y_shift/scale);
        end
        
    end
    
    
    if (sling_recorded == 0) &&  x_shift == 0 && y_shift == 0;
        gen_sling_coord = sling_coord;
        sling_recorded = 1;
        
    elseif sling_recorded == 1;
        if sling_recorded == 1;
            
            background_displacement = background_displacement + [x_shift_scaled,y_shift_scaled];
        end
        bird_coord = bird_pixel;
        for i = 1:size(bird_pixel,1)
            bird_coord(i,1) = scale*bird_pixel(i,1)- background_displacement(1)-gen_sling_coord(1);
            bird_coord(i,2) = gen_sling_coord(2) - background_displacement(2)-scale*bird_pixel(i,2);
            bird_coord(i,3) = 1;
        end
        prev_bird_coord =  bird_coord
        
        
    end
    
    
    
    
    
    
    drawnow
    delete(frame_obj)
    % fps counter
    %     if frame_count == 10
    %         frame_count = 1;
    %         toc_1 = toc;
    %         time_per_frame = (toc_1 - toc_0)/10;
    %         frame_per_sec = 1/time_per_frame;
    %         msg = sprintf('FPS: %.1f\n', frame_per_sec);
    %         fprintf([clc_str, msg]);
    %         clc_str = repmat(sprintf('\b'), 1, length(msg));
    %         toc_0 = toc_1;
    %     end
    frame_count = frame_count + 1;
    
    frame_prev = frame;
end
