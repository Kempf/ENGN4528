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
% loop = [28 31]; % yellow birds
% loop = [37 40]; % black birds
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

%jrajectory
coord_store = NaN(2,3);
para_traj = NaN(1,3);


frame_prev = readFrame(video); 
coord_store = NaN(2,3); % store the coordinates to sketch the parabolic curves
para_traj = NaN(1,3); % parabolic trajectory of each frame
init_trajectory = NaN(1,3); % initialized trajectory( trajectory used to calculate the world coordnates)
init_frame = NaN; % the frame which the bird is launched
frame_number = 1; % current frame number
Vx = NaN; % velocity in x direction
world_coord = [NaN,NaN]; %world coordnate system

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
    frame_py = impyramid(frame,'reduce');
%     
    figure(1)
%     % draw frame
    frame_obj = image(frame);
    hold on
    
    % detect slingshot
    if en_sling
        [sling_coordt,rec_s,rec_drawn_s] = Filter_Slingshot(frame);
    end
    
%     % detect red birds
    if  en_red
        [red_coord,rec_r,rec_drawn_r] = Filter_Red(frame);
    end
    
%     % detect blue birds
    if en_blue
        [blue_coord,rec_b,rec_drawn_b] = Filter_Blue(frame_py);
    end
    
    % detect yellow bird
    if en_yellow
        [yellow_coord,rec_y,rec_drawn_y] = Filter_Yellow(frame);
    end
    
%     % black birds
    if en_black
        [black_coord,rec_k,rec_drawn_k] = Filter_Black(frame_py);
    end
    
    %no detection 
    % detect white bird
    if en_white
        [white_coord,rec_w,rec_drawn_w] = Filter_White(frame);
    end
    
%    % detect pigs
    if en_pig
        [pig_coord,rec_g,rec_drawn_g] = Filter_Pig(frame);
    end
  
    velocity = OpticsBackground(frame_prev,frame,1);

    drawnow
    % fps counter
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