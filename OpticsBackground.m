function velocity = OpticsBackground(frame_prev,frame)
    frame_py = impyramid(frame,'reduce');
    frame_py_prev = impyramid(frame_prev,'reduce');
    C = corner(rgb2gray(frame_py(40:150,100:200,:)),10);
    C(:,1)= C(:,1)+100;  C(:,2)=C(:,2)+40;
    
    d_list = [];
    for i = 1:size(C,1)
            window_0 = double(rgb2gray(prev_frame_py(C(i,2)-w:C(i,2)+w,C(i,1)-w:C(i,1)+w,:)));
            window_1 = double(rgb2gray(frame_py(C(i,2)-w:C(i,2)+w,C(i,1)-w:C(i,1)+w,:)));
            rectangle('Position',[C(i,1)-w,C(i,2)-w,2*w,2*w],'EdgeColor','m','LineWidth',2);
            Ix = conv2(window_0,[-1 1; -1 1], 'valid');
            Iy = conv2(window_0, [-1 -1; 1 1], 'valid');
            It = conv2(window_0, ones(2), 'valid') + conv2(window_1, -ones(2), 'valid');
            Ix = Ix(:); Iy = Iy(:); b = -It(:);
            A = [Ix Iy];
            B = A'*A;
            R = A'*b;
            d = 2*((inv(B)*R)');
            d_list = [d_list;d];
        end
        velocity = sum(d_list,1)/size(C,1);
    

end