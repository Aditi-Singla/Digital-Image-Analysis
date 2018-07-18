clear all; close all; clc;

img = imread('images/flower.jpg');
img = double(img)/ 255.0;

% Energy Function
% mag = rgb2gray(img);
% acc = getEnergyMap(mag);
% figure, imshow(acc);
% imwrite(acc,'EnergyMap.jpg');

% Resize the imag by seam insertion or seam carving
resizeImage(img);

% Content Aware Amplification

% [rows,cols,~] = size(img);
% img1 = imresize(img, 1.1);
% [rows1,cols1,~] = size(img1);
% img2 = carveVertSeams(img1,cols1-cols);
% img3 = carveHorizSeams(img2,rows1-rows);
% figure, imshow(img);