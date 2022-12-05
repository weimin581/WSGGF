
close all;
clear all;
addpath 'WSGGF'
addpath 'FWSGGF'

% Recovered results of Fig. 7 (g) and Fig. 7 (h) in our paper.
I=double(imread('./55.png'))/255; % Input Low-Light Image 55.png from LOL dataset.
p = I;
[m, n, channel] = size(p);
%%% Set parameter
r = 12;   
r2 = 1;   
s = 4;
epsilon = 0.01;     
lamda = 0.4;
%%%%%%%%%%%%%%%%% The proposed WSGGF  %%%%%%%%%%%%%%%%
WSGGF_res = WSGGF(I,p,r,epsilon,r2);
WSGGF_gamma = imadjust(WSGGF_res, [], [], lamda);
result_WSGGF = WSGGF_gamma + (I - WSGGF_res);
figure(1); imshow([I, result_WSGGF],[0,1]); 
%%%%%%%%%%%%%%%%% Our fast version FWSGGF  %%%%%%%%%%%%%%%%
FWSGGF_res = FWSGGF(I,p,r,epsilon,r2,s);
FWSGGF_gamma = imadjust(FWSGGF_res, [], [], lamda);
result_FWSGGF = FWSGGF_gamma + (I - FWSGGF_res);
figure(2); imshow([I, result_FWSGGF],[0,1]);





