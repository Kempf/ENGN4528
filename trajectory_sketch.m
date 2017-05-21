function [coord_store,para_traj] = trajectory_sketch(frame_count,birds)

if mod(frame_count,6) == 0
    coord_store = NaN(2,3);
    coord_store(1,1) = birds(x);
    coord_store(1,2) = birds(y);
else 
    if mod(frame_count,6) == 1
        coord_store(2,1) = birds(x);
        coord_store(2,2) = birds(y);
    else 
        if mod(frame_count,6) == 2
            coord_store(3,1) = birds(x);
            coord_store(3,2) = birds(y);
        end
    end
end

if sum(isnan(coord_store)) == 0
    x = coord_store(1,:);
    y = coord_store(2,:);
    para_traj = polyfit(x,y,2);
end

pix_x = 0:1:birds(x);
pix_y = para_traj(1)*pix_x^2+para_traj(2)*pix_x+para_traj(3);
plot(pix_x,pix_y,'k');
drawnow;

end
    
    