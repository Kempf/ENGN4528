function birds = collide_detect( birds, birds_prev, ground_vel)
if ground_vel(1)<0.2 && ground_vel(2)<0.2
    % birds whose state is 1
    brid_state1 = birds( birds(:,3) == 1);
    brid_state1_prev = birds_prev( birds_prev(:,3) == 1);
    if sum(find(bird_state1(:,1) < brid_state1_prev(:,1))) ~=0
        bird_state2 = brid_state1(find(bird_state1(:,1) < brid_state1_prev(:,1)));
        bird_state2(:,3) = 2;
        bird_state(find(bird_state2(:,1) == brid_state(:,1))) = bird_state2;
    end
end
    
end