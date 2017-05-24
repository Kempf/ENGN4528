function [object_coord]=detection(state_of_detection,frame)

object_coord=[];

frame_py = impyramid(frame,'reduce');

if state_of_detection(1)
        [sling_coord,rec_drawn_s] = Filter_Slingshot(frame);
        object_coord=[object_coord;sling_coord,zeros(size(sling_coord,1),3)];
    end
    
    %     % detect red birds
    if  state_of_detection(2)
        [red_coord,rec_r,rec_drawn_r] = Filter_Red(frame);
        object_coord=[object_coord;red_coord,1*ones(size(red_coord,1),3)];
    end
    
    %     % detect blue birds
    if state_of_detection(3)
        [blue_coord,rec_b,rec_drawn_b] = Filter_Blue(frame_py);
        object_coord=[object_coord;blue_coord,2*ones(size(blue_coord,1),3)];
    end
    
    % detect yellow bird
    if state_of_detection(4)
        [yellow_coord,rec_y,rec_drawn_y] = Filter_Yellow(frame);
        object_coord=[object_coord;yellow_coord,3*ones(size(yellow_coord,1),3)];
    end
    
    %     % black birds
    if state_of_detection(5)
        [black_coord,rec_k,rec_drawn_k] = Filter_Black(frame);
        object_coord=[object_coord;black_coord,4*ones(size(black_coord,1),3)];
    end
    
    % detect white bird
    if state_of_detection(6)
        [white_coord,rec_w,rec_drawn_w] = Filter_White(frame);
        object_coord=[object_coord;white_coord,5*ones(size(white_coord,1),3)];
    end
    
    %    % detect pigs
   	[pig_coord,rec_g,rec_drawn_g] = Filter_Pig(frame);
    object_coord=[object_coord;pig_coord,6*ones(size(pig_coord,1),3)];
end