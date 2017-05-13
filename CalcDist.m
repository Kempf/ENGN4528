function dist = CalcDist(img,img_ave,eigb)
    img = rgb2gray(img);
    img = imresize(img,[30,30]);
    img = img(:);
    

    a_window = projimage(img,img_ave,eigb);
    dist = (double(img) - (img_ave + eigb*a_window))/900;
    dist = norm(dist);

end