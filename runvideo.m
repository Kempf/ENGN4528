close all
clear all
clc

fVid = figure('Name','Angry Birds');

if ismac
    video = VideoReader('Angry Birds In-game Trailer-quicktime.mov');
    % Need this for me(Jae) to work on Macbook
    % Mac cannot read avi video
else
    video = VideoReader('Angry Birds In-game Trailer.avi');
end

% video start and end
% loop = [37 40]; % black birds
% loop = [12 18]; % red birds
% %loop = [15 20]; % pigs 1
% loop = [25 28]; % pigs 2 
%loop = [31 36]; % pigs 3
loop = [1,40];

video.CurrentTime = loop(1);
toc_0 = 0;
tic
frame_count = 1;

[eigb_red,img_ave_red] = find_eigbird_red(15);


win_size = [19,21];



while hasFrame(video)
    if video.CurrentTime >= loop(2)
        video.CurrentTime = loop(1);
    end
    
    if ~ishghandle(fVid)
        break
    end
    
    frame = readFrame(video);
    
%     subplot(1,2,1)
    image(frame)
    %%
    frame_med(:,:,1) = medfilt2(frame(:,:,1),[3,3]);
    frame_med(:,:,2) = medfilt2(frame(:,:,2),[3,3]);
    frame_med(:,:,3) = medfilt2(frame(:,:,3),[3,3]);

    
    
    frame_red_bird = CropColour(frame_med,[140,220,0,30,30,70]);
    frame_black_bird = CropColour(frame_med,[0,30,0,30,0,30]);
    frame_pig = CropColour(frame_med,[100,150,200,230,30,90]);
    
    if sum(sum(frame_red_bird)) >= 5
        [frame_red_bird,rec_r] = Filter(frame_red_bird);
        coord_r = confirm_red_bird(frame,img_ave_red,eigb_red,rec_r);
    end
    

    if sum(sum(frame_black_bird)) >= 5
        [frame_black_bird,region_k] = Filter_Black(frame_black_bird);
    end
    
    if sum(sum(frame_pig)) >= 5
        [frame_pig,region_p] = Filter_Pig(frame_pig);
    end
    
    
    
    
    
    
    
%     subplot(1,2,2)
%     image(frame_pig*1000)
%     %
%     [centres,radii] = imfindcircles(frame,[10,14],'Sensitivity',0.95,'EdgeThreshold',0.3...
%         ,'ObjectPolarity','dark');
%     viscircles(centres, radii,'EdgeColor','b');
%         [centres,radii] = imfindcircles(frame,[10,14],'Sensitivity',0.95,'EdgeThreshold',0.3...
%         ,'ObjectPolarity','dark');

    
% %     
    
    
    
    
    %% PCA part
    % for i = 1:size(region)
    %     rec = region(i).BoundingBox;
    %     bird_found = 0;
    %     for w = win_size
    %
    %         x_list =round(rec(1)+floor(w/2):5:rec(1)+rec(3)-floor(w/2));
    %         y_list =round(rec(2)+floor(w/2):5:rec(2)+rec(4)-floor(w/2));
    %
    %         for y = y_list
    %             for x = x_list
    %
    % %                 x
    % %                 y
    %                 frame_w = frame(y-floor(w/2):y+floor(w/2),...
    %                     x-floor(w/2):x+floor(w/2),:);
    % %                 subplot(1,2,2)
    % %                 image(frame_w)
    % %                 pause(0.5)
    %                 dist = CalcDist_Red(frame_w,img_ave_red,eigb_red);
    %
    %                 if dist <= 1.4
    %                     bird_found = 1;
    %                     rec_bird = rectangle('Position',[x-floor(w/2),y-floor(w/2),w,w]);
    %                     break
    %                 end
    %
    %             end
    %             if bird_found
    %                 break
    %             end
    %         end
    %         if bird_found
    %             break
    %         end
    %
    %     end
    % end
    %%
    
    if frame_count == 10
        clc
        frame_count = 1;
        toc_1 = toc;
        time_per_frame = (toc_1 - toc_0)/10;
        frame_per_sec = 1/time_per_frame
        toc_0 = toc_1;
    end
    
    frame_count = frame_count + 1;
    drawnow
end
