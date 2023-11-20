function res = FWSGGF(I,p,r,eps,r2,s)

[m, n, channel] = size(p);
q_l = zeros(size(p));
q_r = zeros(size(p));
q_u = zeros(size(p));
q_d = zeros(size(p));

q_wn = zeros(size(p));
q_en = zeros(size(p));
q_ws = zeros(size(p));
q_es = zeros(size(p));

res = zeros(size(p));

for i = 1 : channel
    
[q_l(:,:,i),q_r(:,:,i)] = sidewindow_sideweighting_LR_fast(I(:,:,i),p(:,:,i),r,eps,r2,s);

[q_u(:,:,i),q_d(:,:,i)] = sidewindow_sideweighting_UD_fast(I(:,:,i), p(:,:,i), r, eps, r2,s);

[q_wn(:,:,i),q_en(:,:,i),q_ws(:,:,i),q_es(:,:,i)] = sidewindow_sideweighting_WNES_fast(I(:,:,i), p(:,:,i), r, eps, r2, s);

res(:,:,i) = min_distance(q_l(:,:,i),q_r(:,:,i),q_u(:,:,i),q_d(:,:,i),q_wn(:,:,i),q_en(:,:,i),q_ws(:,:,i),q_es(:,:,i),p(:,:,i));

end

end