function bird = confirm_bird(bird,bird_prev,current_time)
for i = 1:size(bird_prev.valid,2)
    for j = 1:size(bird.valid,2)
        pos_diff = norm(bird.coord(j,:) - bird_prev.coord(i,:));
        if pos_diff < 100
            bird.init_t(j) = bird_prev.init_t(i);
        end
        
        if (current_time - bird.init_t(j))>0.1
            bird.valid(j) = 1;
            rectangle('Position',bird.rec(j,:),'Curvature',[1,1],'EdgeColor','g','LineWidth',2);  
        end
        
    end
end


end
