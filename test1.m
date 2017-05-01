clc
close all
clear all
testpath ='bird_test_image/';
trainpath = 'bird_train_image/redbird/';
filename = [testpath 'testimage5.png'];
file = '*bird*.png';

train_filenames = dir([trainpath file]);

img_orig = imread(filename);
% img_r = CropColour(img_orig,[180,220,0,30,35,65]);



img = rgb2gray(img_orig);
tic
% img_dou  = double(img);as 
% img_r_dou = double(img_r);
% 
% 
% img = img_dou .* img_r_dou;
% 
% ind = find(img == 0);
% img(ind) = 255; 
% % img = uint8(img_r);
% imshow(img)
img = img(:);


[eigb_red,img_ave_red]= find_eigbird_red(15);
a_train = projimage_train_red(eigb_red,img_ave_red);

a_test = projimage(img,img_ave_red,eigb_red);

imshow(uint8(reshape(img_ave_red,[30,30])))


dist = double(img) - (img_ave_red + eigb_red*a_test);
disp = norm(dist)/900
toc
% i = 1;
% num_train = size(a_train,2);
% a_dist_list = zeros(1,num_train);
% for a_tr = a_train
%     a_diff = a_test - a_tr;
%     a_dist = norm(a_diff);
%     a_dist_list(i) = a_dist;
%     i = i + 1;
% end
% 
% [~,ind] = sort(a_dist_list);
% 
% % a_dist_closest = a_dist_list(ind(1))
% max(a_dist_list)
% 
% figure()
% 
% subplot(1,2,1)
% imshow(img_orig)
% subplot(1,2,2)
% 
% filename = [trainpath train_filenames(ind(1)).name];
% imshow(imread(filename));