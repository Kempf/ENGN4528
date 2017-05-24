function [t] = coordinate_display(object_coord)
t=[];
for i = 1 : size(object_coord,1)
  	t(i)=text(object_coord(i,1),object_coord(i,2),[[num2str(object_coord(i,4)),',',num2str(-object_coord(i,5))]]);
end;
end