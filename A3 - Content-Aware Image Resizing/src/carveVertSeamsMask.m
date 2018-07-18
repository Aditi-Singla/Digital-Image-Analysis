function [carved, mask, seams] = carveVertSeamsMask(img, n, mask)
    carved = img;
    seams = zeros(size(img,1),n);
    for seam=1:n
        disp(seam);
        vert = accMinVertPathMapMask(carved, mask);
        v = findVertSeam(vert);
        carved = vertSeamCarve(carved, v);
        mask = vertSeamCarveMask(mask, v);
        v = min(v,size(carved,2));
        seams(:,n-seam+1) = v;
    end;