function sky = enhanceSky(rgbImg)
    labImg = rgb2lab(rgbImg);
    greyImg = rgb2gray(rgbImg); 
    
    figure, imshow(rgbImg);
    title('Sky Input');
    
    bChannel = labImg(:,:,3);
    a = zeros(size(labImg, 1), size(labImg, 2));
    b = cat(3, a, a, bChannel);
    %Blue Component of image
    mask = b(:,:,3) < 0;
    mask1 = greyImg;
    for i = 1:size(mask,1)
        for j = 1:size(mask,2)
            if mask(i,j) == 0.00 
                mask1(i,j) = 0.00;
            end    
        end 
    end
    mask1 = im2double(mask1);
    mask1 = cat(3,mask1,mask1,mask1);
    %figure, imshow(mask1);
    
    %Transfer color
    %Borrowed from a github repo
    GRAPH = false;

    target = {};
    gsource = {};
    csource = {};
    target.image = im2double(mask1);
    gsource.image = im2double(imread('greySky.jpg'));
    csource.image = im2double(imread('coloredSky.jpg'));

    csource.lab = rgb2lab(csource.image);
    if ndims(gsource.image) == 3
        gsource.lab = rgb2lab(gsource.image);
    else
        gsource.lab = gsource.image;
    end
    if ndims(target.image) == 3
        target.lab = rgb2gray(target.image); 
    else
        target.lab = target.image;
    end

    csource.luminance = luminance_remap(csource.lab, target.lab);
    gsource.luminance = luminance_remap(gsource.lab, target.lab);
    target.luminance = target.lab;

    transferred = image_colorization_jitter_sampling(target, csource, GRAPH);
    sky = lab2rgb(transferred);
    sky = im2uint8(sky);

    for i = 1:size(mask,1)
        for j = 1:size(mask,2)
            if (mask(i,j)==0.00)
                sky(i,j,:) = rgbImg(i,j,:);
            end    
        end 
    end
    figure, imshow(sky);
    title('Sky Output');
end