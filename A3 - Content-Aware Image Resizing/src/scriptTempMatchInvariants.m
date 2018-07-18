clear all; close all; clc;

im = imread('images/castle.jpg');
temp = imread('images/castleTemp.jpg');
% [temp, ~] = imcrop(im);
% imwrite(temp,'images/balloonsTemp.png');

tempR = rotateImage(temp,-45);
figure, imshow(tempR);
imwrite(tempR,'rotated.jpg');

mask = tempMatchRotation(im,tempR);
figure,imshow(mask);
imwrite(mask,'rotatedmask.jpg');

tempS = imresize(temp,5/6);
figure, imshow(tempS);
imwrite(tempR,'resized.jpg');

mask = tempMatchScaling(im,tempS);
figure,imshow(mask);
imwrite(mask,'rotatedresized.jpg');