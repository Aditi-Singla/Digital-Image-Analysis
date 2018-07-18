function carved = insertVertSeams(img, n)
    carved = img;
    vertSeams = zeros(size(img,1),n);
    for seam=1:n
        vert = accMinVertPathMap(carved);
        v = findVertSeam(vert);
        vertSeams(:,seam) = v;
        carved = vertSeamCarve(carved, v);
    end;
    printVertSeams(img,vertSeams);
    v = modifyOrder(vertSeams);
    carved = vertSeamInsert(img, v);