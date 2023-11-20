close all;
clear all;

%%%%%%%%%%%%%%%%%%%%%%%%% three-channel %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
original = im2double(imread('testdata/tulips.bmp')); %p�����˲�ͼ��
I = im2double(imread('testdata/tulips.bmp')); %I������ͼ��

r = 16;
epsilon = 0.1^2;
r2 = 1;
s = 8;

%{
%%%%%%%%%%%%%%%%%%%%%�㷨1�� GDGIF %%%%%%%%%%%%%%%%%
tic;
[GDGIF_8(:,:,1),mean_a(:,:,1)] = gguidedfilter(I(:,:,1),original(:,:,1),r,epsilon, r2);%%%Rͨ��
[GDGIF_8(:,:,2),mean_a(:,:,2)] = gguidedfilter(I(:,:,2),original(:,:,2),r,epsilon, r2);%%%Gͨ��
[GDGIF_8(:,:,3),mean_a(:,:,3)] = gguidedfilter(I(:,:,3),original(:,:,3),r,epsilon, r2);%%%Bͨ��
toc;
I_enhanced_GDGIF_8 = (I - GDGIF_8) * 5 + GDGIF_8;

tic;
[GDGIF_9(:,:,1),wav_a(:,:,1)] = gguidedfilter_9(I(:,:,1),original(:,:,1),r,epsilon, r2);%%%Rͨ��
[GDGIF_9(:,:,2),wav_a(:,:,2)] = gguidedfilter_9(I(:,:,2),original(:,:,2),r,epsilon, r2);%%%Gͨ��
[GDGIF_9(:,:,3),wav_a(:,:,3)] = gguidedfilter_9(I(:,:,3),original(:,:,3),r,epsilon, r2);%%%Bͨ��
toc;
I_enhanced_GDGIF_9 = (I - GDGIF_9) * 5 + GDGIF_9;

figure(1);
imshow([GDGIF_8, GDGIF_9],[0,1]);
figure(2);
imshow([mean_a, wav_a],[0,1]);
figure(3);
imshow([I_enhanced_GDGIF_8, I_enhanced_GDGIF_9],[0,1]);

% %%%%%%%%%%%%%%%%%%%%%�㷨1�� �ߴ������˲�_��� %%%%%%%%%%%%%%%%%
% tic;
% [SGUI_res(:,:,1)] = sidewindowguidedfilter_8w(I(:,:,1),original(:,:,1),r,epsilon);%%%Rͨ��
% [SGUI_res(:,:,2)] = sidewindowguidedfilter_8w(I(:,:,2),original(:,:,2),r,epsilon);%%%Gͨ��
% [SGUI_res(:,:,3)] = sidewindowguidedfilter_8w(I(:,:,3),original(:,:,3),r,epsilon);%%%Bͨ��
% toc;
% I_enhanced_SGIF = (I - SGUI_res) * 5 + SGUI_res;
% 
% %%����PSNR
% psnr_sub=psnr(I_enhanced_SGIF,original);
% fprintf('\n the psnr value is %0.4f',psnr_sub);
% fprintf('\n');
%}

%%%%%%%%%%%%%%%%%%%% �㷨��xx-GIF %%%%%%%%%%%%%%%%
tic;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%���±ߴ�
[GDGIF_res_l(:,:,1),GDGIF_res_r(:,:,1)] = sidewindow_sideweighting_LR_fast(I(:,:,1),original(:,:,1),r,epsilon,r2,s);%%%Rͨ��
[GDGIF_res_l(:,:,2),GDGIF_res_r(:,:,2)] = sidewindow_sideweighting_LR_fast(I(:,:,2),original(:,:,2),r,epsilon,r2,s);%%%Gͨ��
[GDGIF_res_l(:,:,3),GDGIF_res_r(:,:,3)] = sidewindow_sideweighting_LR_fast(I(:,:,3),original(:,:,3),r,epsilon,r2,s);%%%Bͨ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%���ұߴ�
[GDGIF_res_u(:,:,1),GDGIF_res_d(:,:,1)] = sidewindow_sideweighting_UD_fast(I(:,:,1),original(:,:,1),r,epsilon,r2,s);%%%Rͨ��
[GDGIF_res_u(:,:,2),GDGIF_res_d(:,:,2)] = sidewindow_sideweighting_UD_fast(I(:,:,2),original(:,:,2),r,epsilon,r2,s);%%%Gͨ��
[GDGIF_res_u(:,:,3),GDGIF_res_d(:,:,3)] = sidewindow_sideweighting_UD_fast(I(:,:,3),original(:,:,3),r,epsilon,r2,s);%%%Bͨ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%WNES�ߴ�
[GDGIF_res_wn(:,:,1),GDGIF_res_en(:,:,1),GDGIF_res_ws(:,:,1),GDGIF_res_es(:,:,1)] = sidewindow_sideweighting_WNES_fast(I(:,:,1),original(:,:,1),r,epsilon,r2,s);%%%Rͨ��
[GDGIF_res_wn(:,:,2),GDGIF_res_en(:,:,2),GDGIF_res_ws(:,:,2),GDGIF_res_es(:,:,2)] = sidewindow_sideweighting_WNES_fast(I(:,:,2),original(:,:,2),r,epsilon,r2,s);%%%Gͨ��
[GDGIF_res_wn(:,:,3),GDGIF_res_en(:,:,3),GDGIF_res_ws(:,:,3),GDGIF_res_es(:,:,3)] = sidewindow_sideweighting_WNES_fast(I(:,:,3),original(:,:,3),r,epsilon,r2,s);%%%Bͨ��
toc;



q = ones(size(I));
for i=1:3
%%���ѡ����
q(:,:,i)=min_distance(GDGIF_res_l(:,:,i),GDGIF_res_r(:,:,i),GDGIF_res_u(:,:,i),GDGIF_res_d(:,:,i),GDGIF_res_wn(:,:,i),GDGIF_res_en(:,:,i),GDGIF_res_ws(:,:,i),GDGIF_res_es(:,:,i),original(:,:,i));
end

I_enhanced = (I - q) * 5 + q;


imshow([I,I-q+0.5,I_enhanced],[0,1]);

% %%����PSNR
% psnr_1=psnr(q,I);
% fprintf('\n the psnr value is %0.4f',psnr_1);
% fprintf('\n');

%%����PSNR
psnr_2=psnr(I_enhanced,I);
fprintf('\n the psnr value is %0.4f',psnr_2);
fprintf('\n');

% imwrite(I,'C:\Users\sunkaiand\Desktop\��������\2.aggregation result\Aggregation\ssim\4.2\p.png');
% imwrite(q,'C:\Users\sunkaiand\Desktop\��������\2.aggregation result\Aggregation\ssim\4.2\q.png');
% imwrite(I_enhanced,'C:\Users\sunkaiand\Desktop\��������\2.aggregation result\Aggregation\ssim\4.2. img_dehancement\I_enhanced.png');


% %%%%%%%%%%%%%%%%%%%%%%��ʾ���
% figure(1);
% imshow([SGUI_res,q_x],[0,1]);
% figure(2);
% imshow([I_enhanced_SGIF,I_enhanced_x],[0,1]);
%}
%{
% % figure(2);
% % imshow([I_enhanced_SGIF,I_enhanced_GDGIF,I_enhanced_x],[0,1]);
% 
% % %%%%%%%%%GIF
% % [psnr1,snr1]=psnr(original,GUI_res);
% % fprintf('\n the psnr1 value is %0.6f',psnr1);
% % fprintf('\n');
% % 
% % %%%%%%%%%SWGIF
% % [psnr2,snr2]=psnr(original,SGUI_res);
% % fprintf('\n the psnr2 value is %0.6f',psnr2);
% % fprintf('\n');
% % 
% % %%%%%%%%%GDGIF
% % [psnr3,snr3]=psnr(original,GDGIF_res);
% % fprintf('\n the psnr3 value is %0.6f',psnr3);
% % fprintf('\n');
% % 
% % %%%%%%%%%XX-GIF
% % [psnr4,snr4]=psnr(original,q_x);
% % fprintf('\n the psnr4 value is %0.6f',psnr4);
% % fprintf('\n');
% 
% imwrite(original,'C:\Users\sunkaiand\Desktop\SWF+Fusion\sidewindow\ssim\cat\GIF.png');
% imwrite(GUI_res,'C:\Users\sunkaiand\Desktop\SWF+Fusion\sidewindow\ssim\cat\GIF.png');
% imwrite(SGUI_res,'C:\Users\sunkaiand\Desktop\SWF+Fusion\sidewindow\ssim\cat\SGIF.png');
% imwrite(GDGIF_res,'C:\Users\sunkaiand\Desktop\SWF+Fusion\sidewindow\ssim\cat\GDGIF_res.png');
% imwrite(q_x,'C:\Users\sunkaiand\Desktop\SWF+Fusion\sidewindow\ssim\cat\q_x.png');
%}