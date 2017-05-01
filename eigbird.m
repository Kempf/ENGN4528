close all
clear all
clc


trainpath = 'bird_train_image/';
file = '*bird*.png';
train_filenames = dir([trainpath file]);
num_train = size(train_filenames,1);

img_mat = zeros(30*30, num_train);
for i = 1:num_train
    filename = [trainpath train_filenames(i).name];
    img = rgb2gray(imread(filename));
    img_mat(:,i) = img(:);
end

img_sum = sum(img_mat,2);
img_ave = img_sum/num_train;

% IMG_AVE = reshape(img_ave,[30,30]);
% imshow(uint8(IMG_AVE))

img_mat = img_mat - repmat(img_ave,1,num_train);
A = img_mat;
C = img_mat*img_mat';

[v,~] = eig(A'*A);
u = A*v;
u = normc(u); %Normalise the eigen vectors

eig_val = u'*C*u.*eye(num_train,num_train);
eig_val = sum(eig_val,2);

[~,ind] = sort(eig_val);
ind = flipud(ind);
eig_val = eig_val(ind);
eig_face = u(:,ind);

k = 15;
eig_val= eig_val(1:k);
eig_face = eig_face(:,1:k);

% % %% Display the eigenfaces
% % figure()
% % j = 1;
% % for ef = eig_face
% %     subplot(5,3,j)
% %     ef = reshape((256/2)+ef*30*30,[30,30]);
% %     imshow(uint8(ef))
% %     j = j + 1;
% % end
% % %%

trainpath = 'bird_train_image/';
filename = [trainpath 'whitebird_271.png'];
img = rgb2gray(imread(filename));
img_orig = img;
img = img(:);
img = double(img);
img = img - img_ave;

a = img' * eig_face;
img_proj = img_ave + eig_face*a';
img_proj = reshape(img_proj,[30,30]);
figure();
subplot(1,2,1)
imshow(img_orig)
subplot(1,2,2)
imshow(uint8(img_proj))









