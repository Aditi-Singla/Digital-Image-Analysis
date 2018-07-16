function shadow = rectifyShadow(rgbImg)    
    figure, imshow(rgbImg);
    title('Shadow Input');
    
    YCbCr = rgb2ycbcr(rgbImg);
    Y = YCbCr(:,:,1);
    Cb = YCbCr(:,:,2); 
    Cr= YCbCr(:,:,3);

    greyImg = double(Y);
    greyImg = greyImg./max(greyImg(:));

    pixels = greyImg;
    reshape(pixels,1,[]);
    dark = [];
    bright = [];

    for i = 1:size(pixels)
        if (pixels(i)<=50.0/255)
            dark = [dark, pixels(i)];
        else
            bright = [bright, pixels(i)];
        end    
    end
    fsal = (prctile(bright,35))/(prctile(dark,95));
    fsal = min(2,fsal);
    %fprintf('f = %s\n',fsal);

    base = wlsFilter(greyImg);
    detail = imsubtract(greyImg,base);
    %figure, imshow(base);

    map = simpsal(rgbImg);
    mapbig = mat2gray(imresize(map,[size(rgbImg,1) size(rgbImg,2)]));
    figure, imshow(mapbig);

    newBase = base;
    for i = 1:size(base,1)
        for j = 1:size(base,2)
            if (newBase(i,j)>0.05)
                newBase(i,j) = (fsal*mapbig(i,j)*base(i,j))+((1-mapbig(i,j))*base(i,j));
            end
        end
    end
    
    figure, imshow(newBase);
    newBase = imadd(newBase,detail);
    %figure, imshow(newBase);
    newBase = im2uint8(newBase);
    combinedImg = cat(3,newBase,Cb,Cr);
    %figure, imshow(combinedImg);
    shadow = ycbcr2rgb(combinedImg);
    figure, imshow(shadow);
    title('Shadow output');
end