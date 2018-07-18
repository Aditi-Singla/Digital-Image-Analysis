% Cut the vertical seams from the source image
%
% input
% -----
% img : 3-d array of the source image
% horizSeam : 1-d array of the vertical seams
% 
% output
% ------
% carved : 3-d array of the image with the seams removed
function mask1 = vertSeamCarveMask(mask, vertSeam)
    [dimY, dimX] = size(mask);
    mask1 = zeros(dimY, dimX-1);
    vertSeam = min(vertSeam,dimX);
    vertSeam = max(vertSeam,1);
    for j=1:dimY
        % cut the seam out of the image
        mask1(j,:) = mask(j,[1:vertSeam(j)-1,vertSeam(j)+1:dimX]);
    end;