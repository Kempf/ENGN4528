function dist = CalcDist_Red(img,img_ave_red,eigb_red)
    img = rgb2gray(img);
    img = imresize(img,[30,30]);
    img = img(:);
    

    a_window = projimage(img,img_ave_red,eigb_red);
    dist = double(img) - (img_ave_red + eigb_red*a_window);
    dist = norm(dist)/900;

end