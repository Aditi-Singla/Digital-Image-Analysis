
clear all; close all; clc;

disp('Starting...');

% disp('Face Enhancement...');
% rgbImg = imread('Face1.png');
% face = enhanceFace(rgbImg);

% disp('Sky Enhancement...');
% rgbImg = imread('Sky2.jpg');
% sky = enhanceSky(rgbImg);
 
disp('Shadow Rectification...');
rgbImg = imread('Pic.jpg');
shadow = rectifyShadow(rgbImg);
imwrite(shadow, 'output.jpg');
% disp('Starting...');
% rgbImg = imread('Capture7.png');
% 
% disp('Face Enhancement...');
% face = enhanceFace(rgbImg);
% 
% disp('Sky Enhancement...');
% sky = enhanceSky(face);
% 
% disp('Shadow Rectification...');
% shadow = rectifyShadow(sky);