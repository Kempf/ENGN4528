function [frame_thre] = CropColour(frame,thre)
     R_thre = (frame(:,:,1) >= thre(1)) & (frame(:,:,1) <= thre(2));
     G_thre = (frame(:,:,2) >= thre(3)) & (frame(:,:,2) <= thre(4));
     B_thre = (frame(:,:,3) >= thre(5)) & (frame(:,:,3) <= thre(6));

     frame_thre = R_thre & G_thre & B_thre;


end