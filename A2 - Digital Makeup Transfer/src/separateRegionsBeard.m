function mask_beard = separateRegionsBeard(refImg, landmarkfile)
    
    load(landmarkfile);
    length = size(refImg,1);
    width = size(refImg,2);
    
    % Beard Area
    mask_beard = poly2mask(Ys(1:17), Xs(1:17), length, width);
    % Lips
    mask_lips = poly2mask(Ys(18:28), Xs(18:28), length, width);
    
    for i = 1:length
        for j = 1:width
            if (mask_lips(i,j) == 1)
                mask_beard(i,j) = 0;
            end    
        end
    end    
    figure, imshow(mask_beard);
    title('beard');
end    