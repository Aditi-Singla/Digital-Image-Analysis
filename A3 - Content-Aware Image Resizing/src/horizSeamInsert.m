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
function carved = horizSeamInsert(img, horizSeamList)
    [dimY, dimX, dimD] = size(img);
    numSeams = size(horizSeamList,1);
    carved = zeros(dimY+numSeams, dimX, dimD);
    
    indices = [repmat([1:dimY]',1,dimX); horizSeamList];
    indices = sort(indices,1);
    for x=1:dimX
        for y = 1:dimY+numSeams
            % add a seam in the image
            carved(y,x,:) = img(indices(y,x),x,:);
        end;
    end;