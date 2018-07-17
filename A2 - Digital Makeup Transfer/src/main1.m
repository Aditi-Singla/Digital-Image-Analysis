clear all; close all; clc;

refImgFilename = 'ReferenceBeard.jpg';
origImgFilename = 'OriginalBeard.jpg';
landmarkfile = 'landmarksBeard.mat';

refImg = imread(refImgFilename);
origImg = imread(origImgFilename);

figure, imshow(refImg); title('Initial: Reference');
figure, imshow(origImg); title('Initial: Original');

[rowsA, colsA, nA] = size(origImg); 
[rowsB, colsB, nB] = size(refImg); 
if rowsB ~= rowsA || colsA ~= colsB 
    refImg = imresize(refImg, [rowsA colsA]); 
end

rows = rowsA;
cols = colsA;

%%  3.1. Face Alignment

% % 1. Learn a model for Landmark detection
% compile
% % 2. Detect Control points and then, warp the image
% faceAlign(model, refImgFilename, origImgFilename);

% getLandmarkPoints(refImgFilename,origImgFilename,landmarkfile);

commandStr = sprintf('python faceWarp.py %s %s',refImgFilename,origImgFilename);
[status, ~] = system(commandStr);
if status==0
    fprintf('Image warped using delaunay triangles');
end
    
alignedFace = imread('warped.jpg');
refImg = alignedFace;
figure, imshow(alignedFace); title('After 3.1');


%%  3.2. Layer Decomposition

[mask_beard] = separateRegionsBeard(refImg, landmarkfile);
load(landmarkfile);

% RGB to LAB Conversion
origLab = rgb2lab(origImg);
origL = origLab(:,:,1);
origA = origLab(:,:,2);
origB = origLab(:,:,3);

ref1Img = alignedFace;
refLab = rgb2lab(ref1Img);
refL = refLab(:,:,1);
refA = refLab(:,:,2);
refB = refLab(:,:,3);

% figure, imshow(origL, [1,100]); title('origL');
% figure, imshow(refL, [1,100]); title('refL');

% figure, imshow(origA, [1,100]); title('origA');
% figure, imshow(refA, [1,100]); title('refA');
% 
% figure, imshow(origB, [1,100]); title('origB');
% figure, imshow(refB, [1,100]); title('refB');

origBase = wlsFilter(origL);
refBase = wlsFilter(refL);
origDetail = origL - origBase;
refDetail = refL - refBase;

figure, imshow(origBase, [1,100]); title('origBase');
figure, imshow(refBase, [1,100]); title('refBase');

% figure, imshow(origDetail); title('origDetail');
% figure, imshow(refDetail); title('refDetail');


%%  3.3. Skin Detail Transfer

deltaOrig = 0.5;
deltaRef = 0.5;

resultantDetail = (deltaOrig * origDetail) + (deltaRef * refDetail);

figure, imshow(resultantDetail); title('resultantDetail');

%%  3.4. Color Transfer

gamma = 0.8;
resultantA = origA * (1-gamma) + refA * (gamma);
resultantB = origB * (1-gamma) + refB * (gamma);

for i = 1:rows
    for j = 1:cols
        if mask_beard(i,j) == 0
            resultantDetail(i,j) = origDetail(i,j);
            resultantA(i,j) = origA(i,j);
            resultantB(i,j) = origB(i,j);
        end    
    end 
end

origL1 = imadd(origBase,resultantDetail);
coloredImg = lab2rgb(cat(3,origL1,resultantA,resultantB));

figure, imshow(coloredImg); title('After 3.4');
