function world_coord = coordinate_calculation(world_coord,init_trajectory,frame_number,init_frame,Vx)
world_coord(1) = Vx*2+(frame_number-init_frame);
world_coord(2) = init_trajectory(1)*world_coord(1)^2+init_trajectory(2)*world_coord(1)+init_trajectory(3);
end