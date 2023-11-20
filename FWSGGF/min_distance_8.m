function q=min_distance_8(q_l,q_r,q_u,q_d,q_wn,q_en,q_ws,q_es,p)
%%最后选择结果

[hei,wid,num]=size(p);
A1 = cat(3,q_l,q_r,q_u,q_d,q_wn,q_en,q_ws,q_es);
A2 = cat(3,p,p,p,p,p,p,p,p);

[absmin,index] = min(abs(A1-A2),[],3);

q = zeros(hei,wid);
for ii = 1 : 8
    CC = A1(:,:,ii);
    index1 = find(index==ii);
    q(index1) = CC(index1);
end

end