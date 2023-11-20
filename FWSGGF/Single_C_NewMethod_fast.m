
close all;
clear all;
%%%%%%%%%%%%%%%%%%%%%%%%% single-channel %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% original = im2double(imread('testdata/cat.bmp')); %p�����˲�ͼ��
% I = im2double(imread('testdata/cat.bmp')); %I������ͼ��

p = im2double(imread('C:\Users\sunkaiand\Desktop\zhudeida_date\0004.png')); %p�����˲�ͼ��
I = p; %I������ͼ��


r = 10;           % ԭʼ�˲��뾶
r2=1;            % adaptive term radius
epsilon = 1; % ���򻯲���
s = 1;           % �²���ϵ��

%%%%%%%%%%%%%%%%%  the proposed :WSGDGIF  %%%%%%%%%%%%%%%%
tic;

q_WSGDGIF = WSGDGIF(I,p,r,epsilon,r2,s);


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%(1):���±ߴ�
% [GDGIF_res_l,GDGIF_res_r] = sidewindow_sideweighting_LR_fast(I,original,r,epsilon,r2,s);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%(2):���ұߴ�
% [GDGIF_res_u,GDGIF_res_d] = sidewindow_sideweighting_UD_fast(I,original,r,epsilon,r2,s);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%(3):WNES�ߴ�
% [GDGIF_res_wn,GDGIF_res_en,GDGIF_res_ws,GDGIF_res_es] = sidewindow_sideweighting_WNES_fast(I,original,r,epsilon,r2,s);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   :��ʼ��
% q_x = ones(size(I));
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   :���ѡ����
% for i=1:1
% 
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%: 8���ڼ��㲿��
% q_x(:,:,i)=min_distance_8(GDGIF_res_l(:,:,i),GDGIF_res_r(:,:,i),GDGIF_res_u(:,:,i),...
%                         GDGIF_res_d(:,:,i),GDGIF_res_wn(:,:,i),GDGIF_res_en(:,:,i),...
%                        GDGIF_res_ws(:,:,i),GDGIF_res_es(:,:,i),original(:,:,i));        
% end
toc;
%%����PSNR
psnr_sub=psnr(q_WSGDGIF,p);
fprintf('\n the psnr value is %0.4f',psnr_sub);
fprintf('\n');

% %%%%%%%%%%%%%%%%%%%%%%��ʾ���
figure(1);
imshow([ p, q_WSGDGIF],[0,1]);

imwrite(p,'C:\Users\sunkaiand\Desktop\WSGDGIF\compute_ssim\p.png');
imwrite(q_WSGDGIF,'C:\Users\sunkaiand\Desktop\WSGDGIF\compute_ssim\q_WSGDGIF.png');


