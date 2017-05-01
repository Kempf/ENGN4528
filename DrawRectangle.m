function rec_list = DrawRectangle(bird,colour)
    
    if isempty(bird) == 1
        rec_list = [];
    end
    
    
    rec_list = zeros(1,length(bird));
    
    
    for i = 1:length(bird)
        rec = rectangle('Position',bird(i).BoundingBox,'EdgeColor',colour,'LineWidth',2);
        rec_list(i) = rec;
    end
    
    
end