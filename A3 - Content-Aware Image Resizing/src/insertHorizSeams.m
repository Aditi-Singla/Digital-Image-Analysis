function carved = insertHorizSeams(img, n)
    carved = img;
    horizSeams = zeros(n,size(img,2));
    for seam=1:n
        horiz = accMinHorizPathMap(carved);
        h = findHorizSeam(horiz);
        horizSeams(seam,:) = h;
        carved = horizSeamCarve(carved, h);
    end;
    printHorizSeams(img,horizSeams);
    h = modifyOrder(horizSeams');
    carved = horizSeamInsert(img, h');