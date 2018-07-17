function dt = getTrianglePoints(im, model, thresh)
    bs = detect(im, model, thresh);
    bs = clipboxes(im, bs);
    bs = nms_face(bs,0.3);

    boxes = bs(1);
    figure,
    imagesc(im);
    hold on;
    axis image;
    axis off;

    for b = boxes,
        X = zeros(size(b.xy,1));
        disp(class(X));
        Y = zeros(size(b.xy,1));
        for l = size(b.xy,1):-1:1;
            x1 = b.xy(l,1);
            y1 = b.xy(l,2);
            x2 = b.xy(l,3);
            y2 = b.xy(l,4);
            plot((x1+x2)/2,(y1+y2)/2,'r.','markersize',15);
            p = size(b.xy,1)-l+1;
            X(p) = ((x1+x2)/2);
            Y(p) = ((y1+y2)/2);
        end   
    end
    drawnow;
    LpX = X(:,1);
    LpX = LpX(:);
    LpY = Y(:,1);
    LpY = LpY(:);
    dt = delaunayTriangulation(LpX , LpY);
    hold on 
    triplot(dt);
    hold on
end

