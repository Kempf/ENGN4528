function dist = CalcDist_Red(img)
    img = rgb2gray(img);
    img = img(:);
    [eigb_red,img_ave_red]= find_eigbird_red(15);

a_test = projimage(img,img_ave_red,eigb_red);



end