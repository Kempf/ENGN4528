function coord = confirm_red_bird(frame,img_ave_red,eigb_red,colour_detected_rec)

if isempty(colour_detected_rec) == 0
    
    for rec = colour_detected_rec'
        
        
        
        frame_w = frame(rec(2):rec(4)+rec(2),...
            rec(1):rec(3)+rec(1),:);
        dist = CalcDist_Red(frame_w,img_ave_red,eigb_red);
        if dist < 2
            r = rectangle('Position',rec','EdgeColor','cyan','LineWidth',2);
            
        end
    end
    
    
    
else
    coord = [];
    return
    
    
end

coord = [1,1];

end