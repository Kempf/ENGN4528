%function [state_of_detection]=FSM(coord_state_type)
%coord_state_type = n x 4 matrix, containing 
%    coordinate x, y / birds moving
%   state(1=moving bird, 0 = steady object)
%    type of objects: 
% 0--slingshot
% 1--red
% 2--blue
% 3--yellow
% 4--black
% 5--white
% 6--pig

%state of FSM
% 0:before bird flying, 1:after bird flying ,before bird collapse, 2:after
% bird collaspe
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
 loop = [22 28]; % blue birds
% loop = [28 31]; % yellow birds
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

frame = readFrame(video);

object_coord=[];
m=eye(3);
coord_trajectory=[];
signal_tform=0;
signal_sling=0;

% don't use function names as variables!
%text=[];
point=[];
traj=[];

state=-1;
state_of_detection=[1,0,0,0,0,0];
move_bird=zeros(1,4);

thre=0;
b_1=[];
b_2=[];
b_3=[];
b_coord=[];

y=[];

w=[];

egg=0;
msg = '';

while hasFrame(video)
    if ~ishghandle(fVid)
        break
    end
    
    frame_prev =frame;
    frame = readFrame(video);
    figure(1)
    frame_obj = image(frame);

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
    
    
    if isempty(object_coord)~=1
    move_bird=object_coord(find(object_coord(:,3) <0),:);
    end;
    
    object_coord=detection(state_of_detection,frame);
    sling_coord=object_coord(find(object_coord(:,3)==0),1:2);
    
    if signal_tform
        if signal_sling==0
            sling_position=object_coord(1,1:2);
            signal_sling=1;
        end;
        %calculate tform matrix
        [scale_ratio,x_shift,y_shift,tform]=scale_shift(frame_prev,frame);
        if isempty(move_bird)~=1
            move_bird(4:6)=[move_bird(1:2),1]/m-[sling_position,0];
            %plot parabolic
            coord_trajectory=[coord_trajectory;move_bird(4:6)+[sling_position(1:2),0]];
            [point,traj]=trajectory_sketch(coord_trajectory,m);
        end;
        m=m*tform;
        if isempty(object_coord)~=1
            for i = 1 : size(object_coord,1)
                object_coord(i,4:6)=[object_coord(i,1:2),1]/m-[sling_position,0];
            end;
            %display object coordinates
            %???
            %text=coordinate_display(object_coord);
            
        end;
    end
    drawnow
    %sling is detected first time
    if state == -1 && isempty(sling_coord)~=1
        %???
        pre_sling_coord=sling_coord;
        state=0;
        state_of_detection=[1,1,1,1,1,1];
        %enable all detection
        enable_state=0;
        continue;
   	end;
    hold off;
    %after sling is detected
	if state == 0
        %disable other detection function if slingshot is steady
        %start calculating tform matrix
        if enable_state==0 && abs(sling_coord(1)-pre_sling_coord(1))<0.01
            state_of_detection=[0,0,0,0,0,0];
            signal_tform=1;
            for i = 1 : size(object_coord,1)
                %object_coord i+1(0 is sling) is the same object with
                %state_of_detection i(1 is sling)
                state_of_detection(object_coord(i,3)+1)=1;
            end;
            %enable detected birds when sling is stayble
            enable_state=1;
            continue;
        elseif enable_state==0
            %sling not stayble
            pre_sling_coord=sling_coord;
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
            continue;
        end;
   	end;
    
    if state == 1
        %disable slingshot detection if it is unnecessary
        if state_of_detection(1)~=0 && isempty(object_coord(find(object_coord(:,3)<0)))
            state_of_detection(1)=0;
        end;
        %calculate which one is the move bird in new frame
        if size(object_coord,1) == 1
            object_coord(3)=-object_coord(i,3);
        elseif size(object_coord,1) > 1
            for i = 1 : size(object_coord,1)
                if object_coord(i,4)+object_coord(i,5)-move_bird(4)-move_bird(5)<20 && object_coord(i,4)>move_bird(4) && object_coord(i,3)~=0
                    object_coord(i,3)=-object_coord(i,3);
                    no_move_bird=0;
                    %%%collaspe
                    break;
                    
                else
                    no_move_bird=1;
                end;
            end;
        elseif isempty(object_coord)
            continue;
        end;
        
        % ???blue bird
        if no_move_bird==1 && move_bird(3)==-2
            state=-2;
            continue;
        end;
        
        if no_move_bird==1 && move_bird(3)==-3
            state=-3;
            continue;
        end;
        
        if no_move_bird==1 && move_bird(3)==-5
            state=-5;
            continue;
        end;
        
        %%%collapse???
        if (abs(tform(3,1))<1 && (isempty(object_coord)==1 || no_move_bird==1)) || no_move_bird==1||(object_coord(find(object_coord(:,3)<0),4)-move_bird(4)<0.5)
            state=2;
            signal_tform=0;
            continue;
        end;
        %%%special bird trajectory ploting and detection
        continue;
    end;

    % stage change detection
    %%%some problem with ending with only pig
    if state== 2 && (isempty(object_coord)==1|| (isempty(find(object_coord(:,3)==1))|| ...
                                                   isempty(find(object_coord(:,3)==2))||...
                                                   isempty(find(object_coord(:,3)==3))||...
                                                   isempty(find(object_coord(:,3)==4))||...
                                                   isempty(find(object_coord(:,3)==5)))==0 )
        signal_tform=0;
        signal_sling=0;
        state_of_detection=[0,0,0,0,0,0];
        coord_trajectory=[];
        sling_coord=[];
        sling_position=[];
        m=eye(3);
        state=3;
        continue;
    end;
    
    if state==3 && isequal(frame,255*ones(320,480,3))
        state_of_detection=[1,0,0,0,0,0];
        state=-1;
        continue;
    end;
    
    %blue bird seperation
    if state == -2 
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
            continue;
        end;
        if size(b_coord,1)==1 && thre==0
            num=find(object_coord(:,3)==2);
            if isempty(num)~=1
                object_coord(num(1,1),1:3)=[b_coord(:)',-2];
                if num>1
                    for i = 2 : size(num,1)
                        object_coord(num(i,1),:)=[0 0 0 0 0 0];
                    end;
                end;
                continue;
            else
                object_coord=[object_coord;[b_coord(:)',-2,0,0,1]];
                continue;
            end;
            
        end;
        if size(b_coord,1)==3 && thre ==0
            if max(b_coord(:,1))<209
                value=b_coord(:,2);
                b_1=[b_1;[b_coord(find(b_coord(:,2)==max(value)),:),1]/m];
                b_2=[b_2;[b_coord(find(b_coord(:,2)==median(value)),:),1]/m];
                b_3=[b_3;[b_coord(find(b_coord(:,2)==min(value)),:),1]/m];
                trajectory_sketch(b_1,m);
                trajectory_sketch(b_2,m);
                trajectory_sketch(b_3,m);
                continue;
            else
                thre=1;
                continue;
            end;
        else
            continue;
        end;
%         if thre==1 || size(find(object_coord(:,3)==2),1)>1
%             thre=1;
%             if size(find(object_coord(:,3)==2),1)==3
%                 value=[object_coord(find(object_coord(:,3)==2),2)];
%                 b_1=[b_1;object_coord(find(object_coord(:,2)==max(value)),4:6)+[sling_position(1:2),0]];
%                 b_2=[b_1;object_coord(find(object_coord(:,2)==median(value)),4:6)+[sling_position(1:2),0]];
%                 b_3=[b_3;object_coord(find(object_coord(:,2)==min(value)),4:6)+[sling_position(1:2),0]];
%                 trajectory_sketch(b_1,m);
%                 trajectory_sketch(b_2,m);
%                 trajectory_sketch(b_3,m);
%                 thre=1;
%                 continue;
%             else
%                 continue;
%             end;
%             
%         elseif size(find(object_coord(:,3)==2),1)==1 && thre==0
%             object_coord(find(object_coord(:,3)==2),3)=-2;
%             continue;
%         end;
        continue;
    end;
    if state == -3 
        if isempty(find(object_coord(:,3)==3))~=1
            y=[y;object_coord(find(object_coord(:,3)==3),4:6)+[sling_position(1:2),0]];
            trajectory_sketch(y,m);
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
            continue;
        end;
    end;
    
    %white bird
    if state == -5 
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
            continue;
        end;
        if egg==0
            if isempty(find(object_coord(:,3)==5))==1
                continue;
            else
                object_coord(find(object_coord(:,3)==5),3)=-5;
                continue;
            end;
        elseif egg==1
            w=[w;object_coord(find(object_coord(:,3)==5),4:6)+[sling_position(1:2),0]];
            trajectory_sketch(w,m);
        end;
    end;     
end