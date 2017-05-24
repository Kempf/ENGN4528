function [] = coordinate_calculation(prev_world_coord,m)
%prev_world_coord:n*3
coord = prev_world_coord'*m;
for i = 1 : size(coord,1)
  	text(coord(i,1),coord(i,2),'[%f,%f]',num2str(coord(i,1)),num2str(coord(i,2)));
end;
end