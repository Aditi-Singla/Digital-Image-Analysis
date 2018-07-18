% Cut the horizontal seams from the source image
%
% input
% -----
% img : 3-d array of the source image
% horizSeam : 1-d array of the horizontal seams
% 
% output
% ------
% carved : 3-d array of the image with the seams removed
function mask1 = horizSeamCarveMask(mask, horizSeam)
    [dimY, dimX] = size(mask);
    mask1 = zeros(dimY-1, dimX);
    horizSeam = min(horizSeam,dimY);
    horizSeam = max(horizSeam,1);
    for i=1:dimX
        % cut the seam out of the image
        mask1(:,i) = mask([1:horizSeam(i)-1,horizSeam(i)+1:dimY],i);
    end;