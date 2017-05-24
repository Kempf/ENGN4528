function coord = trajectory_sketch(coord_store,M)
coord_store1 = coord_store;

if sum(isnan(coord_store)) == 0
    coord_store = [coord_store;ones(3,1)]';
    coord = coord_store*M;
    coord(3,:) = [];
    
    x = coord(1,:);
    y = coord(2,:);
    para_traj = polyfit(x,y,2);
    pix_x = 0:480;
    pix_y = para_traj(1)*pix_x^2+para_traj(2)*pix_x+para_traj(3);
    traj = plot(pix_x,pix_y,'k');
    drawnow;
%     if sum(isnan(coord_store1)) ~= 0
%         init_trajectory = para_traj;
%         init_frame = frame_number;
%         Vx = 0.5 *(coord(1,3)-coord(1,2)+coord(1,2)-coord(1,1));
%     end
end

end
    
    