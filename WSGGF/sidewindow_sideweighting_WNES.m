function [q_wn,q_en,q_ws,q_es]=sidewindow_sideweighting_WNES(I, p, r, eps, r2)
%%% I : guidance image
%%% p : input image
%%% r : filtering radius
%%% r2 : new radius

s = 1;
I_sub=imresize(I,1/s,'nearest');
p_sub=imresize(p,1/s,'nearest');
r_sub=r/s;
[hei,wid]=size(I_sub);

Nh=luboxfilter(ones(hei,wid),r_sub);
temp2 = luboxfilter(I_sub, r_sub)./Nh;  

mean_I_wn = temp2(1:end-r_sub,1:wid);
mean_I_en = temp2(1:end-r_sub,r_sub+1:end);
mean_I_ws = temp2(r_sub+1:end,1:wid);
mean_I_es = temp2(r_sub+1:end,r_sub+1:end);

temp3 = luboxfilter(p_sub, r_sub)./Nh;
mean_p_wn = temp3(1:end-r_sub,1:wid);
mean_p_en = temp3(1:end-r_sub,r_sub+1:end);
mean_p_ws = temp3(r_sub+1:end,1:wid);
mean_p_es = temp3(r_sub+1:end,r_sub+1:end);

temp4 = luboxfilter(I_sub.*p_sub, r_sub)./Nh;
mean_Ip_wn = temp4(1:end-r_sub,1:wid);
mean_Ip_en = temp4(1:end-r_sub,r_sub+1:end);
mean_Ip_ws = temp4(r_sub+1:end,1:wid);
mean_Ip_es = temp4(r_sub+1:end,r_sub+1:end);

cov_Ip_wn = mean_Ip_wn - mean_I_wn .* mean_p_wn; 
cov_Ip_en = mean_Ip_en - mean_I_en .* mean_p_en;
cov_Ip_ws = mean_Ip_ws - mean_I_ws .* mean_p_ws;
cov_Ip_es = mean_Ip_es - mean_I_es .* mean_p_es;

temp5 = luboxfilter(I_sub.*I_sub, r_sub) ./ Nh;
mean_II_wn = temp5(1:end-r_sub,1:wid);
mean_II_en = temp5(1:end-r_sub,r_sub+1:end);
mean_II_ws = temp5(r_sub+1:end,1:wid);
mean_II_es = temp5(r_sub+1:end,r_sub+1:end);

var_I_wn = mean_II_wn - mean_I_wn .* mean_I_wn;
var_I_en = mean_II_en - mean_I_en .* mean_I_en;
var_I_ws = mean_II_ws - mean_I_ws .* mean_I_ws;
var_I_es = mean_II_es - mean_I_es .* mean_I_es;

Nh2 = luboxfilter(ones(hei,wid),r2);
temp22 = luboxfilter(I_sub, r2)./Nh2;

mean_I_wn2 = temp22(1:end-r2,1:wid);
mean_I_en2 = temp22(1:end-r2,r2+1:end);
mean_I_ws2 = temp22(r2+1:end,1:wid);
mean_I_es2 = temp22(r2+1:end,r2+1:end);

temp33 = luboxfilter(I_sub.*I_sub, r2) ./ Nh2;
mean_II_wn2 = temp33(1:end-r2,1:wid);
mean_II_en2 = temp33(1:end-r2,r2+1:end);
mean_II_ws2 = temp33(r2+1:end,1:wid);
mean_II_es2 = temp33(r2+1:end,r2+1:end);

var_I_wn22 = mean_II_wn2 - mean_I_wn2 .* mean_I_wn2; 
var_I_en22 = mean_II_en2 - mean_I_en2 .* mean_I_en2; 
var_I_ws22 = mean_II_ws2 - mean_I_ws2 .* mean_I_ws2; 
var_I_es22 = mean_II_es2 - mean_I_es2 .* mean_I_es2; 

var_wn=(var_I_wn.* var_I_wn22).^0.5;
var_en=(var_I_en.* var_I_en22).^0.5;
var_ws=(var_I_ws.* var_I_ws22).^0.5;
var_es=(var_I_es.* var_I_es22).^0.5;
eps0=(0.001*(max(I_sub(:))-min(I_sub(:))))^2; 
varfinal_wn = (var_wn+eps0)*sum(sum(1./(var_wn+eps0)))/(hei*wid); 
varfinal_en = (var_en+eps0)*sum(sum(1./(var_en+eps0)))/(hei*wid); 
varfinal_ws = (var_ws+eps0)*sum(sum(1./(var_ws+eps0)))/(hei*wid); 
varfinal_es = (var_es+eps0)*sum(sum(1./(var_es+eps0)))/(hei*wid); 

minV_wn = min(var_wn(:));
minV_en = min(var_en(:));
minV_ws = min(var_ws(:));
minV_es = min(var_es(:));

meanV_wn = mean(var_wn(:));
meanV_en = mean(var_en(:));
meanV_ws = mean(var_ws(:));
meanV_es = mean(var_es(:));

alpha_wn = meanV_wn;  
alpha_en = meanV_en;  
alpha_ws = meanV_ws;  
alpha_es = meanV_es; 

kk_wn = -4/(minV_wn-alpha_wn);
kk_en = -4/(minV_en-alpha_en);
kk_ws = -4/(minV_ws-alpha_ws);
kk_es = -4/(minV_es-alpha_es);

w_wn = 1-1./(1+exp(kk_wn*(var_wn-alpha_wn)));
w_en = 1-1./(1+exp(kk_en*(var_en-alpha_en)));
w_ws = 1-1./(1+exp(kk_ws*(var_ws-alpha_ws)));
w_es = 1-1./(1+exp(kk_es*(var_es-alpha_es)));

a_wn = (cov_Ip_wn+eps*w_wn./varfinal_wn) ./ (var_I_wn + eps./varfinal_wn); 
b_wn = mean_p_wn - a_wn .* mean_I_wn; 
a_wn=imresize(a_wn,[size(I,1),size(I,2)],'bilinear');
b_wn=imresize(b_wn,[size(I,1),size(I,2)],'bilinear');


a_en = (cov_Ip_en+eps*w_en./varfinal_en) ./ (var_I_en + eps./varfinal_en); 
b_en = mean_p_en - a_en .* mean_I_en;
a_en=imresize(a_en,[size(I,1),size(I,2)],'bilinear');
b_en=imresize(b_en,[size(I,1),size(I,2)],'bilinear');

a_ws = (cov_Ip_ws+eps*w_ws./varfinal_ws) ./ (var_I_ws + eps./varfinal_ws); 
b_ws = mean_p_ws - a_ws .* mean_I_ws;
a_ws=imresize(a_ws,[size(I,1),size(I,2)],'bilinear');
b_ws=imresize(b_ws,[size(I,1),size(I,2)],'bilinear');

a_es = (cov_Ip_es+eps*w_es./varfinal_es) ./ (var_I_es + eps./varfinal_es); 
b_es = mean_p_es - a_es .* mean_I_es;
a_es=imresize(a_es,[size(I,1),size(I,2)],'bilinear');
b_es=imresize(b_es,[size(I,1),size(I,2)],'bilinear');

q_wn = a_wn .* I + b_wn; 
q_en = a_en .* I + b_en; 
q_ws = a_ws .* I + b_ws; 
q_es = a_es .* I + b_es; 

