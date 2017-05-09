function coord = confirm_black_bird(frame,img_ave_black,eigb_black,colour_detected_rec)
if isempty(colour_detected_rec) == 0
    for rec = colour_detected_rec'
        frame_w = frame(rec(2):rec(4)+rec(2),...
            rec(1):rec(3)+rec(1),:);
        dist = CalcDist_Red(frame_w,img_ave_black,eigb_black);
        if dist < 2
            rectangle('Position',rec+[-5,-5 10 10]','EdgeColor','cyan','LineWidth',2);
        else
            dist
        end
        
    end
else
    coord = [];
    return
    
end

coord = [1,1];


end