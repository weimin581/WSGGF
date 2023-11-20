function [q_l,q_r]=sidewindow_sideweighting_LR(I,p,r,eps,r2)

%%% I : guidance image
%%% p : input image
%%% r : filtering radius
%%% r2 : new radius
s = 1;
I_sub=imresize(I,1/s,'nearest');
p_sub=imresize(p,1/s,'nearest');
r_sub=r/s;
[hei,wid]=size(I_sub);

% [hei,wid,num]=size(I);

N = lboxfilter(ones(hei,wid),r_sub);
temp_I = lboxfilter(I_sub, r_sub)./N;
mean_I_l = temp_I(:,1:wid);  
mean_I_r = temp_I(:,r_sub+1:end);

temp_p = lboxfilter(p_sub, r_sub) ./ N;
mean_p_l = temp_p(:,1:wid);   
mean_p_r = temp_p(:,r_sub+1:end);  

temp_Ip = lboxfilter(I_sub.*p_sub, r_sub) ./ N;
mean_Ip_l = temp_Ip(:,1:wid);     
mean_Ip_r = temp_Ip(:,r_sub+1:end);    

cov_Ip_l = mean_Ip_l - mean_I_l .* mean_p_l; 
cov_Ip_r = mean_Ip_r - mean_I_r .* mean_p_r;

temp_II = lboxfilter(I_sub.*I_sub, r_sub) ./ N;
mean_II_l = temp_II(:,1:wid);     
mean_II_r = temp_II(:,r_sub+1:end);   

var_I_l = mean_II_l - mean_I_l .* mean_I_l;
var_I_r = mean_II_r - mean_I_r .* mean_I_r;

%%%%%%%%%%%%%%%side window weighting%%%%%%%%%%%%%%%
N2 = lboxfilter(ones(hei,wid),r2);
temp_w1 = lboxfilter(I_sub, r2)./N2;
mean_I_l2 = temp_w1(:,1:wid);  
mean_I_r2 = temp_w1(:,r2+1:end);

temp_w2 = lboxfilter(I_sub.*I_sub, r2)./N2;
mean_II_l2 = temp_w2(:,1:wid); 
mean_II_r2 = temp_w2(:,r2+1:end);

var_I_l2 = mean_II_l2 - mean_I_l2 .* mean_I_l2; %the 3*3 variance of image I_l 
var_I_r2 = mean_II_r2 - mean_I_r2 .* mean_I_r2; %the 3*3 variance of image I_r 

var_l=(var_I_l.*var_I_l2).^0.5;
var_r=(var_I_r.*var_I_r2).^0.5;

eps0=(0.001*(max(I_sub(:))-min(I_sub(:))))^2; 
varfinal_l = (var_l+eps0)*sum(sum(1./(var_l+eps0)))/(hei*wid);    
varfinal_r = (var_r+eps0)*sum(sum(1./(var_r+eps0)))/(hei*wid);    

minV_l = min(var_l(:));
meanV_l = mean(var_l(:));
alpha_l = meanV_l;  
kk_l = -4/(minV_l-alpha_l);
w_l = 1-1./(1+exp(kk_l*(var_l-alpha_l)));    

minV_r = min(var_r(:));
meanV_r = mean(var_r(:));
alpha_r = meanV_r;  
kk_r = -4/(minV_r-alpha_r);
w_r = 1-1./(1+exp(kk_r*(var_r-alpha_r)));   

a_l = (cov_Ip_l+eps * w_l ./ varfinal_l) ./ (var_I_l + eps ./ varfinal_l ); 
b_l = mean_p_l - a_l .* mean_I_l;

a_r = (cov_Ip_r+eps * w_r ./ varfinal_r) ./ (var_I_r + eps ./ varfinal_r );
b_r = mean_p_r - a_r .* mean_I_r;

w_l = yaxisboxfilter((1./var_l), r_sub);
wav_a_l = (1 ./ w_l) .* yaxisboxfilter((1./var_l) .* a_l, r_sub);
wav_b_l = (1 ./ w_l) .* yaxisboxfilter((1./var_l) .* b_l, r_sub);

wav_a_l=imresize(wav_a_l,[size(I,1),size(I,2)],'bilinear');
wav_b_l=imresize(wav_b_l,[size(I,1),size(I,2)],'bilinear');

q_l = wav_a_l .* I + wav_b_l;

w_r = yaxisboxfilter((1./var_r), r_sub);
wav_a_r = (1 ./ w_r) .* yaxisboxfilter((1./var_r) .* a_r, r_sub);
wav_b_r = (1 ./ w_r) .* yaxisboxfilter((1./var_r) .* b_r, r_sub);
wav_a_r=imresize(wav_a_r,[size(I,1),size(I,2)],'bilinear');
wav_b_r=imresize(wav_b_r,[size(I,1),size(I,2)],'bilinear');
q_r = wav_a_r .* I + wav_b_r;


