function [object_coord]=detection(state_of_detection,frame)

object_coord=[];
frame_py = impyramid(frame,'reduce');

if state_of_detection(1)
        [sling_coord,~] = Filter_Slingshot(frame);
        object_coord=[object_coord;sling_coord,zeros(size(sling_coord,1),3)];
    end
    
    %     % detect red birds
    if  state_of_detection(2)
        [red_coord,~] = Filter_Red(frame);
        object_coord=[object_coord;red_coord,1*ones(size(red_coord,1),3)];
        % if(~(isempty(red_coord)))
            % red_det = 1;
        % end
    end
    
    %     % detect blue birds
    if state_of_detection(3)
        [blue_coord,~] = Filter_Blue(frame);
        object_coord=[object_coord;blue_coord,2*ones(size(blue_coord,1),3)];
        % if(~(isempty(blue_coord)))
            % red_det = 1;
        % end
    end
    
    % detect yellow bird
    if state_of_detection(4)
        [yellow_coord,~] = Filter_Yellow(frame);
        object_coord=[object_coord;yellow_coord,3*ones(size(yellow_coord,1),3)];
        % if(~(isempty(yellow_coord)))
            % red_det = 1;
        % end
    end
    
    %     % black birds
    if state_of_detection(5)
        [black_coord,~] = Filter_Black(frame);
        object_coord=[object_coord;black_coord,4*ones(size(black_coord,1),3)];
        % if(~(isempty(black_coord)))
            % red_det = 1;
        % end
    end
    
    % detect white bird
    if state_of_detection(6)
        [white_coord,~] = Filter_White(frame);
        object_coord=[object_coord;white_coord,5*ones(size(white_coord,1),3)];
        % if(~(isempty(white_coord)))
            % red_det = 1;
        % end
    end
    
    %    % detect pigs
   	[pig_coord,~] = Filter_Pig(frame);
    object_coord=[object_coord;pig_coord,6*ones(size(pig_coord,1),3)];
    % if(~(isempty(pig_coord)))
            % red_det = 1;
    % end
end