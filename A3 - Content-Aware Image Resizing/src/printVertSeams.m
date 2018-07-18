function printVertSeams(img, vertSeam)
    img1 = img;
    [dimY, ~, dimD] = size(img);
    n = size(vertSeam, 2);
    for y = 1:dimY
        for x = 1:n
            img1(y,vertSeam(y,x),1) = 1;
            img1(y,vertSeam(y,x),2) = 0;
            img1(y,vertSeam(y,x),3) = 0;
        end;    
    end;
    figure, imshow(img1);
    imwrite(img1,'seams.jpg');