
close all;
clear all;
%%%%%%%%%%%%%%%%%%%%%%%%% single-channel %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% original = im2double(imread('testdata/cat.bmp')); %p：待滤波图像
% I = im2double(imread('testdata/cat.bmp')); %I：引导图像

p = im2double(imread('C:\Users\sunkaiand\Desktop\zhudeida_date\0004.png')); %p：待滤波图像
I = p; %I：引导图像


r = 10;           % 原始滤波半径
r2=1;            % adaptive term radius
epsilon = 1; % 正则化参数
s = 1;           % 下采样系数

%%%%%%%%%%%%%%%%%  the proposed :WSGDGIF  %%%%%%%%%%%%%%%%
tic;

q_WSGDGIF = WSGDGIF(I,p,r,epsilon,r2,s);


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%(1):上下边窗
% [GDGIF_res_l,GDGIF_res_r] = sidewindow_sideweighting_LR_fast(I,original,r,epsilon,r2,s);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%(2):左右边窗
% [GDGIF_res_u,GDGIF_res_d] = sidewindow_sideweighting_UD_fast(I,original,r,epsilon,r2,s);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%(3):WNES边窗
% [GDGIF_res_wn,GDGIF_res_en,GDGIF_res_ws,GDGIF_res_es] = sidewindow_sideweighting_WNES_fast(I,original,r,epsilon,r2,s);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   :初始化
% q_x = ones(size(I));
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   :最后选择结果
% for i=1:1
% 
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%: 8窗口计算部分
% q_x(:,:,i)=min_distance_8(GDGIF_res_l(:,:,i),GDGIF_res_r(:,:,i),GDGIF_res_u(:,:,i),...
%                         GDGIF_res_d(:,:,i),GDGIF_res_wn(:,:,i),GDGIF_res_en(:,:,i),...
%                        GDGIF_res_ws(:,:,i),GDGIF_res_es(:,:,i),original(:,:,i));        
% end
toc;
%%计算PSNR
psnr_sub=psnr(q_WSGDGIF,p);
fprintf('\n the psnr value is %0.4f',psnr_sub);
fprintf('\n');

% %%%%%%%%%%%%%%%%%%%%%%显示结果
figure(1);
imshow([ p, q_WSGDGIF],[0,1]);

imwrite(p,'C:\Users\sunkaiand\Desktop\WSGDGIF\compute_ssim\p.png');
imwrite(q_WSGDGIF,'C:\Users\sunkaiand\Desktop\WSGDGIF\compute_ssim\q_WSGDGIF.png');


