path = 'unrotated/';
path2 = 'rotated/';
file = 'b*';
num_birds = 5;
filenames = dir([path file]);
gen = @(rot,name1,name2) imwrite(imrotate(imread(name1),rot,'crop'),name2);
for b = 1:num_birds
    filename = [path filenames(b).name];
    for a = 0:19
        gen(a*18,filename,[path2 filename(size(path,2)+1:end-4) num2str(a+1) '.png']);
    end
end