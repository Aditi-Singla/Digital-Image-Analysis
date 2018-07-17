function faceAlign(model, imFile1, imFile2)
    close all;
    im1 = imread(imFile1);
    im2 = imread(imFile2);
    % 5 levels for each octave
    model.interval = 5;
    % set up the threshold
    model.thresh = min(-0.65, model.thresh);

    % Find control points
    for i = 1:2
        im = im1;
        if i == 2
            im = im2;
        end
        
        dt = getTrianglePoints(im, model, model.thresh);
    end
    
    commandStr = sprintf('python faceMorph.py %s %s',imFile1,imFile2);
    [status, ~] = system(commandStr);
    if status==0
        fprintf('Image warped using delaunay triangles');
    end
end