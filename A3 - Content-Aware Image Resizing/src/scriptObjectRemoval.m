clear all; close all; clc;

im = imread('images/castle.jpg');
temp = imread('images/castleTemp.jpg');
% [temp, ~] = imcrop(im);
% imwrite(temp,'images/castleTemp.jpg');

[mask, ~] = fourierMaskTempMatch(im,temp);
% mask = spatialTempMatch(im,temp);
imwrite(mask,'mask.jpg');
figure, imshow(mask);
% mask = houghTempMatch(im,temp);
% figure, imshow(mask);

im = double(im) / 255.0;
[image, mask, seamsList] = carveVertSeamsMask(im,300,mask);

% [x,y] = find(mask==0);
% seamsList = [];
% last = 0;
% current = size(x,1);
% disp(current);
% count = 0;
% image = im;
% while (current > 0) && (count < 2)
%     [image, mask, seams] = carveVertSeamsMask(image,20,mask);
%     [x,y] = find(mask==0);
%     last = current;
%     current =  size(x,1);
%     seamsList = [seams seamsList];
%     if (last == current)
%         count = count + 1;
%     else
%         count = 0;
%     end    
% end

figure, imshow(image);
figure, imshow(mask);

disp('Insertion starts...');

numSeams = size(seamsList,2);
disp(numSeams);
final = image;
imwrite(image, 'removed.jpg');
for i = 1:numSeams
    disp(i);
    final = vertSeamInsert(final, seamsList(:,i));
end
figure, imshow(final);
imwrite(final, 'final.jpg');