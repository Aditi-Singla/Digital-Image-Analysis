clear all; close all; clc;

refImgFilename = 'Reference.jpg';
origImgFilename = 'Original.jpg';
landmarkfile = 'landmarks.mat';

refImg = imread(refImgFilename);
origImg = imread(origImgFilename);

figure, imshow(refImg, 'InitialMagnification', 50); title('Initial: Reference');
figure, imshow(origImg, 'InitialMagnification', 50); title('Initial: Original');

[rowsA, colsA, nA] = size(origImg); 
[rowsB, colsB, nB] = size(refImg); 
if rowsB ~= rowsA || colsA ~= colsB 
    origImg = imresize(origImg, [rowsA colsA]); 
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
figure, imshow(alignedFace, 'InitialMagnification', 50); title('After 3.1');


%%  3.2. Layer Decomposition

[mask_leftEyebrow, mask_rightEyebrow, mask_leftEye, mask_rightEye, mask_lips, mask_face, mask_skin] = separateRegions(refImg, landmarkfile);
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

% figure, imshow(origL, [1,100], 'InitialMagnification', 50); title('origL');
% figure, imshow(refL, [1,100], 'InitialMagnification', 50); title('refL');

% figure, imshow(origA, [1,100], 'InitialMagnification', 50); title('origA');
% figure, imshow(refA, [1,100], 'InitialMagnification', 50); title('refA');
% 
% figure, imshow(origB, [1,100], 'InitialMagnification', 50); title('origB');
% figure, imshow(refB, [1,100], 'InitialMagnification', 50); title('refB');

origBase = wlsFilter(origL);
refBase = wlsFilter(refL);
origDetail = origL - origBase;
refDetail = refL - refBase;

figure, imshow(origBase, [1,100], 'InitialMagnification', 50); title('origBase');
figure, imshow(refBase, [1,100], 'InitialMagnification', 50); title('refBase');

% figure, imshow(origDetail, 'InitialMagnification', 50); title('origDetail');
% figure, imshow(refDetail, 'InitialMagnification', 50); title('refDetail');


%%  3.3. Skin Detail Transfer

deltaOrig = 0.5;
deltaRef = 0.5;
resultantDetail = (deltaOrig * origDetail) + (deltaRef * refDetail);

figure, imshow(resultantDetail, 'InitialMagnification', 50); title('resultantDetail');

%%  3.4. Color Transfer

gamma = 0.8;
resultantA = origA * (1-gamma) + refA * (gamma);
resultantB = origB * (1-gamma) + refB * (gamma);

for i = 1:rows
    for j = 1:cols
        if mask_face(i,j) == 0
            resultantDetail(i,j) = origDetail(i,j);
            resultantA(i,j) = origA(i,j);
            resultantB(i,j) = origB(i,j);
        end    
    end 
end

origL1 = imadd(origBase,resultantDetail);
coloredImg = lab2rgb(cat(3,origL1,resultantA,resultantB));

figure, imshow(coloredImg, 'InitialMagnification', 50); title('After 3.4');


%%  3.5. Highlight and shading transfer

% Calculation of betap

lipPixels = [];
eyesPixels = [];
skinPixels = [];
eyebrowsPixels = [];
facePixels = [];

count1 = 1;
count2 = 1;
count3 = 1;
count4 = 1;
for i = 1:rows
    for j = 1:cols
        if mask_face(i,j)==1
            if mask_lips(i,j)==1
                lipPixels(count1,1) = i;
                lipPixels(count1,2) = j;
                count1 = count1 + 1;
            elseif mask_leftEye(i,j) == 1 || mask_rightEye(i,j) == 1
                eyesPixels(count2,1) = i;
                eyesPixels(count2,2) = j;
                count2 = count2 + 1;
            elseif mask_leftEyebrow(i,j) == 1 || mask_rightEyebrow(i,j) == 1
                eyebrowsPixels(count3,1) = i;
                eyebrowsPixels(count3,2) = j;
                count3 = count3 + 1;
            else 
                skinPixels(count4,1) = i;
                skinPixels(count4,2) = j;
                count4 = count4 + 1;
            end    
        end    
    end
end
numLipPixels = size(lipPixels,1);
numEyesPixels = size(eyesPixels,1);
numEyebrowsPixels = size(eyebrowsPixels,1);
numSkinPixels = size(skinPixels,1);

betap = zeros(rows,cols);

% % Calculate distance matrix for eyebrows
% distanceMat = pdist2(eyebrowsPixels,[eyesPixels; lipPixels]);
% 
% sigmaSq = min(rows,cols)/25;
% distanceMat = distanceMat .* (-1/(2*sigmaSq));
% distanceMat = exp(distanceMat);
% 
% k = ones(numEyebrowsPixels,numEyesPixels+numLipPixels);
% ke = k .* distanceMat;
% ke1 = 1 - ke;
% beta1 = min(ke1,[],2);
% beta1 = min(0.3,beta1);
% 
% for i = 1:numEyebrowsPixels
%     p = eyebrowsPixels(i,:);
%     betap(p(1),p(2)) = beta1(i,1);
% end
% 
% 
% % Calculate distance matrix for skin
% num = 100;
% numPixels = floor(numSkinPixels/num);
% 
% for i = 1:num-1
%     disp(i);
%     distanceMat = pdist2(skinPixels(((i-1)*numPixels)+1 : i*numPixels, :),[eyebrowsPixels; eyesPixels; lipPixels]);
% 
%     sigmaSq = min(rows,cols)/25;
%     distanceMat = distanceMat .* (-1/(2*sigmaSq));
%     distanceMat = exp(distanceMat);
% 
%     v1 = ones(numPixels,numEyebrowsPixels) .* 0.7;
%     v2 = ones(numPixels,numEyesPixels+numLipPixels);
% 
%     k = [v1, v2];
%     ke = k .* distanceMat;
%     ke1 = 1 - ke;
%     beta1 = min(ke1,[],2);
% 
%     for j = 1:numPixels
%         p = skinPixels(((i-1)*numPixels)+j,:);
%         betap(p(1),p(2)) = beta1(j,1);
%     end
% end
% 
% numPixels1 = numSkinPixels - ((num-1)*numPixels);
% distanceMat = pdist2(skinPixels(((num-1)*numPixels)+1 : numSkinPixels, :),[eyebrowsPixels; eyesPixels; lipPixels]);
% 
% sigmaSq = min(rows,cols)/25;
% distanceMat = distanceMat .* (-1/(2*sigmaSq));
% distanceMat = exp(distanceMat);
% 
% v1 = ones(numPixels1,numEyebrowsPixels) .* 0.7;
% v2 = ones(numPixels1,numEyesPixels+numLipPixels);
% 
% k = [v1, v2];
% ke = k .* distanceMat;
% ke1 = 1 - ke;
% beta1 = min(ke1,[],2);
% 
% for j = 1:numPixels1
%     p = skinPixels(((num-1)*numPixels)+j,:);
%     betap(p(1),p(2)) = beta1(j,1);
% end
%     
% % For facial components like eyes and lips, betap remains zero.
% 
% save('betap.mat','betap');
load('betap.mat');

figure, imshow(betap, 'InitialMagnification', 50);

[origGx, origGy] = imgradientxy(origBase);
[refGx, refGy] = imgradientxy(refBase);

[origGmag,~] = imgradient(origBase);
[refGmag,~] = imgradient(refBase);

resultantBaseGx = origGx;
resultantBaseGy = origGy;
for i = 1:rows
    for j = 1:cols
        if (((betap(i,j)*refGmag(i,j)) > origGmag(i,j)) && (refGmag(i,j) < 150))
            resultantBaseGx(i,j) = refGx(i,j);
            resultantBaseGy(i,j) = refGy(i,j);
        end
    end
end

resultantBase = poisson_solver_function(resultantBaseGx,resultantBaseGy,origBase);

rdmin = min(min(resultantBase));
resultantBase = resultantBase - rdmin;
rdmax = max(max(resultantBase));
resultantBase = resultantBase .* (60/rdmax);

resultantL = imadd(resultantBase,resultantDetail);
shadedImg = lab2rgb(cat(3,resultantL,resultantA,resultantB));
figure, imshow(shadedImg, 'InitialMagnification', 50); title('After 3.5');


%%  3.6. Lip Transfer

origHisteqL = histeq(origL./100);
refHisteqL = histeq(refL./100);

M = zeros(size(origImg), 'uint8');

Ip = zeros(numLipPixels,1);
Eq = zeros(numLipPixels,1);

for i = 1:numLipPixels
    p = lipPixels(i,:);
    Ip(i,1) = origHisteqL(p(1),p(2));
    Eq(i,1) = refHisteqL(p(1),p(2));
end

% Calculate distance matrix
N = numLipPixels;
d(N,N) = 0;

for i = 1:(N-1)
    X = ones((N-i),1)*lipPixels(i,:);
    d((i+1):N,i) = sqrt(sum((X - lipPixels((i+1):N,:)).^2,2));
end

distanceMat = d + d';

% Calculate Eq-Ip

Eq1 = repmat(Eq',N,1);
Ip1 = repmat(Ip,1,N);

diffMat = Eq1 - Ip1;

% Gaussian Product

gaussDist = gaussmf(distanceMat, [0.25,0]);
gaussDiff = gaussmf(diffMat, [0.25,0]);

gaussProd = gaussDist .* gaussDiff;

[~,I] = max(gaussProd,[],2);

for i = 1:N
    p = lipPixels(i,:);
    q = lipPixels(I(i,1),:);
    M(p(1),p(2),:) = ref1Img(q(1), q(2),:);
end

% figure, imshow(M, 'InitialMagnification', 50);
shadedImg = im2double(shadedImg);
M = im2double(M);
shadedImgLab = rgb2lab(shadedImg);
MLab = rgb2lab(M);
for i=1:rows
    for j = 1:cols
        if mask_lips(i,j) == 1
            shadedImgLab(i,j,1) = (shadedImgLab(i,j,1) + MLab(i,j,1))/3.1;  % Add M's L component into the image 
            shadedImgLab(i,j,2) = MLab(i,j,2);
            shadedImgLab(i,j,3) = MLab(i,j,3);
        end
    end
end
finalImg = im2uint8(lab2rgb(shadedImgLab));
figure, imshow(finalImg, 'InitialMagnification', 50); title('After 3.6');