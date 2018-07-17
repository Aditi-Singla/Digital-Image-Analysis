function out = myMorph(im1, p_source, p_dest, tri_source, tri_dest)

[h  w] = size(im1);

%get single column vectors for source and destination image control points
Psource_x   = p_source(:,1);
Psource_y   = p_source(:,2);
Pdest_x     = p_dest(:,1);
Pdest_y     = p_dest(:,2);

%for each intermediate frame...

out = zeros(size(im1));


%get triangles. Each array is 3n x 2, where n is the number of triangles
triangles_source = [];
triangles_dest = [];
for i= 1 : size(tri_source,1)
triangle_s = getTriangle(Psource_x,Psource_y,tri_source,i);
triangle_d = getTriangle(Pdest_x,Pdest_y,tri_dest,i);

triangles_source = cat(1,triangles_source,triangle_s);
triangles_dest = cat(1,triangles_dest,triangle_d);
end



%iterate each pixel
for x=1:h
for y=1:w

    %get the source and destination triangle for pixel [x y]

    %source triangle
    for t = 1 : 3 : size(triangles_source, 1)-2

       [w1,w2,w3,inTriangle] = inTri(x,y, ...
                                    triangles_source(t,1),triangles_source(t,2), ...
                                    triangles_source(t+1,1),triangles_source(t+1,2), ...
                                    triangles_source(t+2,1),triangles_source(t+2,2));
       if(inTriangle == 1)
           break;   %point [x,y] must belong to one (and only) triangle
       end
    end

    %source triangle
    for k = 1 : 3 : size(triangles_dest, 1)-2
       [w1d,w2d,w3d,inTriangleD] = inTri(x,y, ...
                                    triangles_dest(k,1),triangles_dest(k,2), ...
                                    triangles_dest(k+1,1),triangles_dest(k+1,2), ...
                                    triangles_dest(k+2,1),triangles_dest(k+2,2));
       if(inTriangleD == 1)
           break;
       end
    end

    v_source = [w1*triangles_source(t,1) + ...
                w2*triangles_source(t+1,1) + ...
                w3*triangles_source(t+2,1), ...
                w1*triangles_source(t,2) + ...
                w2*triangles_source(t+1,2) + ...
                w3*triangles_source(t+2,2)];

    v_dest = [w1d*triangles_dest(k,1) + ...
                w2d*triangles_dest(k+1,1) + ...
                w3d*triangles_dest(k+2,1),...
                w1d*triangles_dest(k,2) + ...
                w2d*triangles_dest(k+1,2) + ...
                w3d*triangles_dest(k+2,2)];


    if(inTriangle ~= 1 && inTriangleD ~= 1)
        continue;
    end

    v_source    = round(v_source);
    v_dest      = round(v_dest);

    if(v_source(1)>0 && v_source(1) <= h && ...
       v_source(2)>0 && v_source(2) <= w && ...
       v_dest(1)>0 && v_dest(1) <= h && ...
       v_dest(2)>0 && v_dest(2) <= w)

   disp('pixel warped')
    out(v_dest(1),v_dest(2)) = im1(v_source(1),v_source(2));
    end
   % else
    %    out(x,y) = im1(x,y); 

end
end