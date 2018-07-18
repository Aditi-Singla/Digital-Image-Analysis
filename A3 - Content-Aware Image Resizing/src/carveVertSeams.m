function carved = carveVertSeams(img, n)
    carved = img;
    figure, imshow(carved);
    for seam=1:n
        vert = accMinVertPathMap(carved);
        v = findVertSeam(vert);
        img1 = carved;
        [dimY, ~, ~] = size(img);
        for y = 1:dimY
            img1(y,v(y),1) = 1;
            img1(y,v(y),2) = 0;
            img1(y,v(y),3) = 0;    
        end;
        imshow(img1);
        carved = vertSeamCarve(carved, v);
        imshow(carved);
    end;