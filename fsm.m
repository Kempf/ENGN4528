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

%state of FSM
% 0:before bird flying, 1:after bird flying ,before bird collapse, 2:after
% bird collaspe
state=-1;
state_of_detection=[0,0,0,0,0,1];
move_bird=zeros(1,4);

while(1)
    detection_code;
    
    if state == -1 && isNAN(x_coord_of_slingshot)==0
        pre_xcoord_of_slingshot=x_coord_of_slingshot;
        state=0;
        state_of_detection=[1,1,1,1,1,1];
        enable_state=0;
        continue;
   	end;
            
	if state == 0
        %disable other detection function if slingshot is steady
        if enable_state==0 && x_coord_of_slingshot-pre_xcoord_of_slingshot<3
            for i = 1 : size(coord_state_type,1)
                state_of_detection(coord_state_type(i,4))=1;
            end;
            enable_state=1;
            continue;
        else
            pre_xcoord_of_slingshot=x_coord_of_slingshot;
            continue;
        end;
        if enable_state==1
            for i = 1 : size(coord_state_type,1)
                if coord_state_type(i,1)-x_coord_of_slingshot > 2
                    coord_state_type(i,3)=1;
                    move_bird=coord_state_type(i,:);
                    state = 1;
                    break;
                end;
            end;
            continue;
        end;
   	end;
    
    if state == 1
        %disable slingshot detection if it is unnecessary
        if state_of_detection(6)~=0 && slingshot_detect==0
            state_of_detection(6)=0;
        end;
        %calculate which one is the move bird in new frame
        for i = 1 : size(coord_state_type,1)
            if coord_state_type(i,1)+coord_state_type(i,2)-move_bird(1)-move_bird(2)<20
                coord_state_type(i,3)=1;
                if  condition
                    state=2;
                    break;
                end;
            end;
            break;
        end;
        continue;
    end;

    % whiteout detection
    if state== 2 && frame == 255 * ones(360,640,3)
        state_of_detection=[0,0,0,0,0,1];
        state=-1;
    end;
end;