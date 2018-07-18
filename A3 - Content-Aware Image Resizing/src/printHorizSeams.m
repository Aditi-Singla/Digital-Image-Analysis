function printHorizSeams(img, horizSeam)
    img1 = img;
    [~, dimX, dimD] = size(img);
    n = size(horizSeam, 1);
    for x = 1:dimX
        for y = 1:n
            img1(horizSeam(y,x),x,1) = 1;
            img1(horizSeam(y,x),x,2) = 0;
            img1(horizSeam(y,x),x,3) = 0;
        end;    
    end;
    figure, imshow(img1);
    imwrite(img1,'seams.jpg');