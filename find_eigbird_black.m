function [eigb_k,img_ave_k] = find_eigbird_black(k)
trainpath = 'images/train/black/';
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
img_ave_k = img_sum/num_train;
img_mat = img_mat - repmat(img_ave_k,1,num_train);
A = img_mat;
C = img_mat*img_mat';

[v,~] = eig(A'*A);
u = A*v;
u = normc(u); %Normalise the eigen vectors

eig_val = u'*C*u.*eye(num_train,num_train);
eig_val = sum(eig_val,2);

[~,ind] = sort(eig_val);
ind = flipud(ind);

eigb_k = u(:,ind);
eigb_k = eigb_k(:,1:k);


% imshow(uint8(reshape(img_ave_k,[30,30])))



end