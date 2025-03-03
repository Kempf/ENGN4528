function [point,traj] = trajectory_sketch(coord_store,M)
%coord_store:n*3 world_coord
point=[];
traj=[];
if size(coord_store,1)>2
    coord = coord_store*M;
    
    x = coord(:,1);
    y = coord(:,2);
    hold on
    for i = 1 : size(coord,1)
        point(i)=plot(coord(i,1),coord(i,2),'ro');
    end;
    para_traj = polyfit(x,y,2);
    pix_x = 0:480;
    pix_y = polyval(para_traj,pix_x);
    traj = plot(pix_x,pix_y,'k');
    text(double(x(end))+5,double(y(end))+5,char(vpa(poly2sym(para_traj),2)));
    
    drawnow;
end

end
    
    