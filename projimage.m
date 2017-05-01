function a = projimage(img,img_ave,eig_bird)
    img = double(img);
    img = img(:);
    img = img - img_ave;
    
    a = (img'*eig_bird)';

end