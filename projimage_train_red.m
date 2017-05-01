function a_train = projimage_train_red(eigb_red,img_ave_red)
trainpath = 'bird_train_image/redbird/';
file = '*bird*.png';
train_filenames = dir([trainpath file]);
num_train = size(train_filenames,1);

k = size(eigb_red,2);
a_tr = zeros(k,num_train);
for i = 1:num_train
    filename = [trainpath train_filenames(i).name];
    img = imread(filename);
    img = rgb2gray(img);
    a_train(:,i) = projimage(img,img_ave_red,eigb_red);
end

end