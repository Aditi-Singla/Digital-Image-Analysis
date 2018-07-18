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
function carved = vertSeamInsert(img, vertSeamList)
    [dimY, dimX, dimD] = size(img);
    numSeams = size(vertSeamList,2);
    carved = zeros(dimY, dimX+numSeams, dimD);
    indices = [repmat([1:dimX],dimY,1) vertSeamList];
    indices = sort(indices,2);
    for y=1:dimY
        for x = 1:dimX+numSeams
            % add a seam in the image
            carved(y,x,:) = img(y,indices(y,x),:);
        end;
    end;   