close all
clear all
clc

warning('off','all');

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

% used for fps counting
video.CurrentTime = loop(1);
toc_0 = 0;
tic
frame_count = 1;
msg = '';

% definition and assignment of useful variables
frame = readFrame(video);

%   detected objects' coordinates/type/slingshot coordinates data matrix
%   type of objects:
%       0--slingshot
%       1--red
%       2--blue
%       3--yellow
%       4--black
%       5--white
%       6--pig
%       -(1~5) means that a specific type(1~5) bird is flying
object_coord=[];

%   transform matrix
m=eye(3);

%   coordinates for trajectory ploting
coord_trajectory=[];

%   signal for whether compute transform matrix, depending on slingshot's
%       movement. 1: yes
signal_tform=0;

%   signal of whether slingshot is detected or not. 1: detected
signal_sling=0;

%   state of FSM
%       State -1: Initialized state (slingshot is not detected)
%       State 0: Launching state (slingshot is steadily detected)
%       State 1: Bird Flying state (a moving bird is detected)
%       State 2: Stop flying state (background steady and no moving bird)
%       State -2: Blue bird extra filtering (first time blue bird is not detected after launching)
%       State -3: Yellow bird acceleration (first time yellow bird is not detected after launching)
%       State -5: White bird extra filtering (first time white bird is not detected after launching)
%       Back to State -1 condition: frame(30,44,2)>220 (a feature pixel value change during stage
state=-1;

%   enable detection or not. sling/red/blue/yellow/black/white. Pig
%   detection are enabled all the time
state_of_detection=[1,0,0,0,0,0];

%   variable for storing fly bird. the same structure with object_coord
move_bird=zeros(1,6);

%   variables for blue bird extra detection
thre=0;
%       extra detection data storing matrix
b_coord=[];
%       sling coordinates after seperation for ploting trajectory
b_1=[];
b_2=[];
b_3=[];


%   sling coordinates after yellow bird's acceleration for ploting trajectory
y=[];

%   variables for white bird extra detection.
%       extra detection data storing matrix.
w_coord=[];
%       sling coordinates after laying a egg for ploting trajectory
w=[];
%       signal of whether the white bird has laid a egg
egg=0;

% FSM implemented by ''if' condition
while hasFrame(video)
    if ~ishghandle(fVid)
        break
    end
    
    frame_prev =frame;
    frame = readFrame(video);
    figure(1)
    frame_obj = image(frame);
    
    %fps demonstration
    if frame_count == 10
        frame_count = 1;
        toc_1 = toc;
        time_per_frame = (toc_1 - toc_0)/10;
        frame_per_sec = 1/time_per_frame;
        msg = sprintf('FPS: %.1f\n', frame_per_sec);
        figure(1);
        toc_0 = toc_1;
    end
    text(0,0,msg);
    frame_count = frame_count + 1;
    
    % find if flying bird exists when any object is detected
    if isempty(object_coord)~=1
        move_bird=object_coord(find(object_coord(:,3) <0),:);
    end;
    
    % detection: fuction to detect all the objects
    object_coord=detection(state_of_detection,frame);
    
    % store slingshot data
    sling_coord=object_coord(find(object_coord(:,3)==0),1:2);
    
    % store slingshot's first stayble coordinates as the origin of sling coordinates.
    if signal_tform
        if signal_sling==0
            sling_position=object_coord(1,1:2);
            signal_sling=1;
        end;
        
        %calculate transform matrix 'tform' between frames by function scal_shift
        [tform]=scale_shift(frame_prev,frame);
        % if bird is flying
        if isempty(move_bird)~=1
            % calculate sling coordinates using transform matrix
            move_bird(4:6)=[move_bird(1:2),1]/m-[sling_position,0];
            % sotre coordinates for ploting trajectory
            coord_trajectory=[coord_trajectory;move_bird(4:6)+[sling_position(1:2),0]];
            %   plot parabolic trajectory
            trajectory_sketch(coord_trajectory,m);
        end;
        % calculate transform matrix 'm' between current coodinates and sling coordinates
        m=m*tform;
        % calculate all the detected objects's sling coordinates
        if isempty(object_coord)~=1
            for i = 1 : size(object_coord,1)
                object_coord(i,4:6)=[object_coord(i,1:2),1]/m-[sling_position,0];
            end;
            %display object coordinates
            %coordinate_display(object_coord);
        end;
    end
    
    drawnow
    % sling is detected first time
    if state == -1 && isempty(sling_coord)~=1
        %store slingshot coordinates of the previous frame
        pre_sling_coord=sling_coord;
        state=0;
        state_of_detection=[1,1,1,1,1,1];
        %enable all detection
        enable_state=0;
        hold off;
        continue;
    end;
    
    %after sling is detected
    if state == 0
        %disable other detection function if slingshot is steady
        %start calculating tform matrix
        if enable_state==0 && isempty(pre_sling_coord)~=1 && isempty(sling_coord)~=1 && abs(sling_coord(1)-pre_sling_coord(1))<0.01
            state_of_detection=[0,0,0,0,0,0];
            signal_tform=1;
            for i = 1 : size(object_coord,1)
                %object_coord i+1(0 is sling) is the same object with
                %state_of_detection i(1 is sling)
                state_of_detection(object_coord(i,3)+1)=1;
            end;
            %enable detected birds when sling is stayble
            enable_state=1;
            hold off;
            continue;
        elseif enable_state==0
            %sling not stayble
            pre_sling_coord=sling_coord;
            hold off;
            continue;
        end;
        if enable_state==1
            for i = 1 : size(object_coord,1)
                if object_coord(i,4) > 15 && object_coord(i,4)<30 &&object_coord(i,3)~=0 && object_coord(i,3)~=6
                    object_coord(i,3)=-object_coord(i,3);
                    %bird is flying
                    state = 1;
                    break;
                end;
            end;
            hold off;
            continue;
        end;
    end;
    
    %after bird launch
    if state == 1
        %disable slingshot detection if it is unnecessary (sling is not detected anymore)
        if state_of_detection(1)~=0 && isempty(object_coord(find(object_coord(:,3)<0)))
            state_of_detection(1)=0;
        end;
        %calculate which one is the move bird in the new frame
        if size(object_coord,1) == 1
            object_coord(3)=-object_coord(i,3);
        elseif size(object_coord,1) > 1
            for i = 1 : size(object_coord,1)
                if object_coord(i,4)+object_coord(i,5)-move_bird(4)-move_bird(5)<20 && object_coord(i,4)>move_bird(4) && object_coord(i,3)~=0
                    object_coord(i,3)=-object_coord(i,3);
                    no_move_bird=0;
                    break;
                    
                else
                    no_move_bird=1;
                end;
            end;
        elseif isempty(object_coord)
            hold off;
            continue;
        end;
        
        %   special bird trajectory ploting and detection
        
        % if blue bird is flying but no move bird is detected(due to imperfection filter)
        %   start extra filtering for blue bird
        if no_move_bird==1 && move_bird(3)==-2
            state=-2;
            hold off;
            continue;
        end;
        
        % if yellow bird is flying but no move bird is detected(due to its acceleration feature)
        %   start new trajectory ploting for yellow bird
        if no_move_bird==1 && move_bird(3)==-3
            state=-3;
            hold off;
            continue;
        end;
        
        % if white bird is flying but no move bird is detected(imperfect filter)
        %   start extra filtering for white bird
        if no_move_bird==1 && move_bird(3)==-5
            state=-5;
            hold off;
            continue;
        end;
        % end special bird
        
        % imperfect collapse detection(normally not reached but for red bird)
        if (abs(tform(3,1))<1 && (isempty(object_coord)==1 || no_move_bird==1)) || no_move_bird==1||(object_coord(find(object_coord(:,3)<0),4)-move_bird(4)<0.5)
            state=2;
            signal_tform=0;
            hold off;
            continue;
        end;
        hold off;
        continue;
    end;
    
    % stage change
    if frame(30,44,2)>220
        signal_tform=0;
        signal_sling=0;
        state_of_detection=[1,0,0,0,0,0];
        coord_trajectory=[];
        sling_coord=[];
        sling_position=[];
        m=eye(3);
        state=-1;
        hold off;
        continue;
    end;
    
    % blue bird seperation
    if state == -2
        % extra detection for blue bird
        b_coord=im_blue(frame);
        if frame(30,44,2)>220
            signal_tform=0;
            signal_sling=0;
            state_of_detection=[1,0,0,0,0,0];
            coord_trajectory=[];
            sling_coord=[];
            sling_position=[];
            m=eye(3);
            state=-1;
            hold off;
            continue;
        end;
        % before seperation: 1 blue bird
        if size(b_coord,1)==1 && thre==0
            num=find(object_coord(:,3)==2);
            % blue bird detected by normal detection
            if isempty(num)~=1
                object_coord(num(1,1),1:3)=[b_coord(:)',-2];
                if num>1
                    for i = 2 : size(num,1)
                        object_coord(num(i,1),:)=[0 0 0 0 0 0];
                    end;
                end;
                hold off;
                continue;
                % blue bird not detected by normal detection:
                %   add extra detection result.
            else
                object_coord=[object_coord;[b_coord(:)',-2,0,0,1]];
                hold off;
                continue;
            end;
            
        end;
        % after seperation: 3 blue birds
        %   distinguish birds by y coordinates: max-1st,median-2nd,min-3rd.
        if size(b_coord,1)==3 && thre ==0
            % hardcode boundary condition for seperated blue birds, can be removed.
            if max(b_coord(:,1))<209
                value=b_coord(:,2);
                b_1=[b_1;[b_coord(find(b_coord(:,2)==max(value)),:),1]/m];
                b_2=[b_2;[b_coord(find(b_coord(:,2)==median(value)),:),1]/m];
                b_3=[b_3;[b_coord(find(b_coord(:,2)==min(value)),:),1]/m];
                % trajectory ploting
                trajectory_sketch(b_1,m);
                trajectory_sketch(b_2,m);
                trajectory_sketch(b_3,m);
                hold off;
                continue;
            else
                thre=1;
                hold off;
                continue;
            end;
        else
            hold off;
            continue;
        end;
    end;
    
    % yellow bird acceleration
    if state == -3
        if isempty(find(object_coord(:,3)==3))~=1
            y=[y;object_coord(find(object_coord(:,3)==3),4:6)+[sling_position(1:2),0]];
            trajectory_sketch(y,m);
            hold off;
            continue;
        end;
        if frame(30,44,2)>220
            state=-1;
            signal_tform=0;
            signal_sling=0;
            state_of_detection=[1,0,0,0,0,0];
            coord_trajectory=[];
            sling_coord=[];
            sling_position=[];
            m=eye(3);
            state=-1;
            hold off;
            continue;
        end;
    end;
    
    %white bird
    if state == -5
        % white bird extra detection
        w_coord=im_white(frame);
        if frame(30,44,2)>220
            state=-1;
            signal_tform=0;
            signal_sling=0;
            state_of_detection=[1,0,0,0,0,0];
            coord_trajectory=[];
            sling_coord=[];
            sling_position=[];
            m=eye(3);
            state=-1;
            hold off;
            continue;
        end;
        % haven't laid egg
        if egg==0
            % two white areas are detected mean 1 bird and 1 egg:
            %   after first disappearing no chance for detecting white birds not moving
            if size(w_coord,1)==2
                egg=1;
                hold off;
                continue;
            elseif size(w_coord,1)==1
                % add if not detected by normal detection
                if isempty(find(object_coord(:,3)==5))==1
                    object_coord=[object_coord;w_coord,-5,0,0,1];
                % manipulate type value
                else
                    object_coord(find(object_coord(:,3)==5),3)=-5;
                    hold off;
                    continue;
                end;
            end;
        % after laying the egg
        elseif egg==1 && isempty(w_coord)~=1
            % store white bird data
            w=[w;[w_coord(1,:),1]/m];
            % plot new trajectory, after laying the egg
            trajectory_sketch(w,m);
            hold off;
            continue;
        end;
    end;
end