function [mask_leftEyebrow, mask_rightEyebrow, mask_leftEye, mask_rightEye, mask_lips, mask_face, mask_skin] = separateRegions(refImg, landmarkfile)
    
    load(landmarkfile);
    length = size(refImg,1);
    width = size(refImg,2);
    % Left Eyebrow
    mask_leftEyebrow = poly2mask(Ys(1:6), Xs(1:6), length, width);
    % figure,
    % imshow(mask_leftEyebrow);
    % title('leftEyebrow');

    % Right Eyebrow
    mask_rightEyebrow = poly2mask(Ys(7:12), Xs(7:12), length, width);
    % figure,
    % imshow(mask_rightEyebrow);
    % title('rightEyebrow');

    % Left Eye
    mask_leftEye = poly2mask(Ys(13:20), Xs(13:20), length, width);
    % figure,
    % imshow(mask_leftEye);
    % title('leftEye');

    % Right Eye
    mask_rightEye = poly2mask(Ys(21:28), Xs(21:28), length, width);
    % figure,
    % imshow(mask_rightEye);
    % title('rightEye');

    % Lips
    mask_lips = poly2mask([Ys(40:46) fliplr(Ys(52:56))], [Xs(40:46) fliplr(Xs(52:56))], length, width);
    % figure,
    % imshow(mask_lips);
    % title('lips');

    % Face
    mask_face = poly2mask(Ys(57:80), Xs(57:80), length, width);
    % figure,
    % imshow(mask_face);
    % title('face');

    % Skin
    mask_skin = mask_face;
    for i=1:size(mask_skin,1)
        for j=1:size(mask_skin,2)
            if mask_face(i,j) == 1 && (mask_leftEye(i,j) == 1 || mask_rightEye(i,j) == 1 || mask_leftEyebrow(i,j) == 1 || mask_rightEyebrow(i,j) == 1 || mask_lips(i,j) == 1)
                mask_skin(i,j) = 0;
            end  
        end    
    end
    % figure,
    % imshow(mask_skin);
    % title('skin');
end    