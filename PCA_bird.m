function bird = PCA_bird(frame,img_ave_black,eigb_black,colour_detected_rec,current_time)
bird.coord = [];
bird.init_t = [];
bird.valid = [];
bird.rec = [];
if isempty(colour_detected_rec) == 0
    for rec = colour_detected_rec'
        frame_w = frame(rec(2):rec(4)+rec(2),rec(1):rec(3)+rec(1),:);
        dist = CalcDist(frame_w,img_ave_black,eigb_black);
        if dist < 1.5
            rectangle('Position',rec','EdgeColor','cyan','LineWidth',2);    
            bird.coord = [bird.coord;[rec(1)+rec(3)/2,rec(2)+rec(4)/2]];
            bird.init_t = [bird.init_t,current_time];
            bird.rec = [bird.rec;rec'];
%         else
%             subplot(1,2,2)
%             image(frame_w)
%             pause(1)
        
        end
    end
else
    return
    
end
bird.valid = zeros(1,size(bird.init_t,2));

end
