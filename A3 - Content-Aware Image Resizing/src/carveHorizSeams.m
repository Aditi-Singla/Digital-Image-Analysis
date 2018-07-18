function carved = carveHorizSeams(img, n)
    carved = img;
    figure, imshow(carved);
    for seam=1:n
        horiz = accMinHorizPathMap(carved);
        h = findHorizSeam(horiz);
        img1 = carved;
        [~, dimX, ~] = size(carved);
        for x = 1:dimX
            img1(h(x),x,1) = 1;
            img1(h(x),x,2) = 0;
            img1(h(x),x,3) = 0;    
        end;
        imshow(img1);
        carved = horizSeamCarve(carved, h);
        imshow(carved);
    end;
    