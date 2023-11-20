function [q_u,q_d]=sidewindow_sideweighting_UD_fast(I, p, r, eps, r2, s)
%%% I : guidance image
%%% p : input image
%%% r : filtering radius
%%% r2 : new radius

I_sub=imresize(I,1/s,'nearest');
p_sub=imresize(p,1/s,'nearest');
r_sub=r/s;

[hei,wid]=size(I_sub);
N=lboxfilter(ones(wid,hei),r_sub);

temp_I = lboxfilter(I_sub', r_sub)./N;
mean_I_u = (temp_I(:,1:hei))';  
mean_I_d = (temp_I(:,r_sub+1:end))';

temp_p = lboxfilter(p_sub', r_sub) ./ N;
mean_p_u = (temp_p(:,1:hei))';    
mean_p_d = (temp_p(:,r_sub+1:end))'; 

temp_Ip = lboxfilter((I_sub.*p_sub)', r_sub) ./ N;
mean_Ip_u = (temp_Ip(:,1:hei))';    
mean_Ip_d = (temp_Ip(:,r_sub+1:end))';  

cov_Ip_u = mean_Ip_u - mean_I_u .* mean_p_u; 
cov_Ip_d = mean_Ip_d - mean_I_d .* mean_p_d;

temp_II = lboxfilter((I_sub.*I_sub)', r_sub) ./ N;
mean_II_u = (temp_II(:,1:hei))';      
mean_II_d = (temp_II(:,r_sub+1:end))';  

var_I_u = mean_II_u - mean_I_u .* mean_I_u;
var_I_d = mean_II_d - mean_I_d .* mean_I_d;

%%%%%%%%%%%%%%%side window weighting%%%%%%%%%%%%%%%
N2 = lboxfilter(ones(wid,hei),r2);
temp_w1 = lboxfilter(I_sub', r2)./N2;
mean_I_u2 = (temp_w1(:,1:hei))';  
mean_I_d2 = (temp_w1(:,r2+1:end))';

temp_w2 = lboxfilter((I_sub.*I_sub)', r2)./N2;
mean_II_u2 = (temp_w2(:,1:hei))';  
mean_II_d2 = (temp_w2(:,r2+1:end))';

var_I_u2 = mean_II_u2 - mean_I_u2 .* mean_I_u2; %the 3*3 variance of image I_l 
var_I_d2 = mean_II_d2 - mean_I_d2 .* mean_I_d2; %the 3*3 variance of image I_r 

var_u=(var_I_u.*var_I_u2).^0.5;
var_d=(var_I_d.*var_I_d2).^0.5;

eps0=(0.001*(max(I_sub(:))-min(I_sub(:))))^2; 
varfinal_u = (var_u+eps0)*sum(sum(1./(var_u+eps0)))/(hei*wid);    
varfinal_d = (var_d+eps0)*sum(sum(1./(var_d+eps0)))/(hei*wid);    

minV_u = min(var_u(:));
meanV_u = mean(var_u(:));
alpha_u = meanV_u;  
kk_u = -4/(minV_u-alpha_u);
w_u = 1-1./(1+exp(kk_u*(var_u-alpha_u)));  

minV_d = min(var_d(:));
meanV_d = mean(var_d(:));
alpha_d = meanV_d;  
kk_d = -4/(minV_d-alpha_d);
w_d = 1-1./(1+exp(kk_d*(var_d-alpha_d)));   

a_u = (cov_Ip_u+eps * w_u ./ varfinal_u) ./ (var_I_u + eps ./ varfinal_u );
b_u = mean_p_u - a_u .* mean_I_u;

a_d = (cov_Ip_d+eps * w_d ./ varfinal_d) ./ (var_I_d + eps ./ varfinal_d );
b_d = mean_p_d - a_d .* mean_I_d;

w_u = yaxisboxfilter((1 ./ var_u ), r_sub)';
wav_a_u = (1 ./ w_u) .* yaxisboxfilter((1./var_u) .* a_u, r_sub)';
wav_b_u = (1 ./ w_u) .* yaxisboxfilter((1./var_u) .* b_u, r_sub)';
wav_a_u=imresize(wav_a_u,[size(I,2),size(I,1)],'bilinear');
wav_b_u=imresize(wav_b_u,[size(I,2),size(I,1)],'bilinear');
q_u = wav_a_u' .* I + wav_b_u';

w_d = yaxisboxfilter((1./var_d), r_sub)';
wav_a_d = (1 ./ w_d) .* yaxisboxfilter((1./var_d) .* a_d, r_sub)';
wav_b_d = (1 ./ w_d) .* yaxisboxfilter((1./var_d) .* b_d, r_sub)';
wav_a_d=imresize(wav_a_d,[size(I,2),size(I,1)],'bilinear');
wav_b_d=imresize(wav_b_d,[size(I,2),size(I,1)],'bilinear');
q_d = wav_a_d' .* I + wav_b_d';
