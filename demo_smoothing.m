close all;
clear all;
addpath 'WSGGF'
addpath 'FWSGGF'

% Recovered results of Fig. 4 (g) and Fig. 4 (h) in our paper.
p = im2double(imread('12.png')); % Input Image 12.png from Set12 dataset.
I = p;
[m, n, channel] = size(p);
r2 = 1;  
%%% set parameter
r = 12; 
epsilon = 0.4^2; 
s = 4; 
%%%%%%%%%%%%%%%%% The proposed WSGGF  %%%%%%%%%%%%%%%%
result_WSGGF = WSGGF(I,p,r,epsilon,r2);
figure(1); imshow([I, result_WSGGF],[0,1]); 
%%%%%%%%%%%%%%%%% Our fast version FWSGGF  %%%%%%%%%%%%%%%%
result_FWSGGF = FWSGGF(I,p,r,epsilon,r2,s);
figure(2); imshow([I, result_FWSGGF],[0,1]);



