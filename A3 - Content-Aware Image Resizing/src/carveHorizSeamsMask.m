function [carved, mask, seams] = carveHorizSeamsMask(img, n, mask)
    carved = img;
    seams = zeros(n,size(img,2));
    for seam=1:n
        disp(seam);
        horiz = accMinHorizPathMapMask(carved, mask);
        h = findHorizSeam(horiz);
        carved = horizSeamCarve(carved, h);
        mask = horizSeamCarveMask(mask,h);
        h = min(h,size(carved,1));
        seams(n-seam+1,:) = h;
    end;