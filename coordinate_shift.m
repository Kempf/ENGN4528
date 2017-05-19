function [x_shift,y_shift,difference]=coordinate_shift(frame_old,frame_new)
%position of the window, may influence the result 
window=[size(frame_old,1)*0.8 size(frame_old,2)*0.8
        size(frame_old,1)*0.9 size(frame_old,2)*0.9];
    
%how many pixels to detect the shift, decide the largest shift scale that can be detected    
detect_length=40;

difference=zeros(detect_length);
min=[10000 0 0];
for i = -detect_length/2+1 : detect_length/2
    for j = -detect_length/2+1 : detect_length/2
        shift_window=window-[i j; i j];
        difference(i+detect_length/2,j+detect_length/2)=sum(sum(abs(frame_new(shift_window(1,1,:):shift_window(2,1,:),shift_window(1,2,:):shift_window(2,2,:))...
            -frame_old(window(1,1,:):window(2,1,:),window(1,2,:):window(2,2,:)))));
        if difference(i+detect_length/2,j+detect_length/2)<min(1)
            min=[difference(i+detect_length/2,j+detect_length/2),i,j];
        end;
    end;
end;
difference=min(1);
x_shift=min(2);
y_shift=min(3);
end