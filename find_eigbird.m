function [eigb,img_ave]= find_eigbird(k)
trainpath = 'images/train/';
file = '*b*.png';
train_filenames = dir([trainpath file]);
num_train = size(train_filenames,1);
fprintf('Training images: %d\n',num_train);
img_mat = zeros(30*30, num_train);
for i = 1:num_train
    filename = [trainpath train_filenames(i).name];
    img = rgb2gray(imread(filename));
    img = imresize(img,[30,30]);
    img_mat(:,i) = img(:);
end
img_sum = sum(img_mat,2);
img_ave = img_sum/num_train;
% imshow(reshape(uint8(img_ave),[30,30]))
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
% eig_val = eig_val(ind);
eigb = u(:,ind);

% eig_val= eig_val(1:k);
eigb = eigb(:,1:k);

% % Display the eigenfaces
% figure()
% j = 1;
% for ef = eigb
%     subplot(5,3,j)
%     ef = reshape((256/2)+ef*30*30,[30,30]);
%     imshow(uint8(ef))
%     title(num2str(j))
%     j = j + 1;
% end
%

end