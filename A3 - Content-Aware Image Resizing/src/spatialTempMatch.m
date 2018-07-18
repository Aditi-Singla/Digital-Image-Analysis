function mask = spatialTempMatch(im, temp)

    imInitial = im;
    
    %% Template Image
    temp = rgb2gray(temp);
    temp = edge(temp,'canny');
    [x,y] = find(temp>0);
    b = size(x);

    %median of indices x and y
    x_m = floor(mean(x));
    y_m = floor(mean(y));

    Dy = imfilter(double(temp),[1; -1],'same');
    Dx = imfilter(double(temp),[1  -1],'same');
    I = mod(radtodeg(atan2(Dy,Dx))+180, 180); %imaginary part

    % making of R-table
    R = zeros(10,b(1),2);
    index = ones(10,1);
    for p = 1:size(x)
        angle = ceil(I(x(p),y(p))/20);
        if angle == 0
            R(10,index(10,1),1)=  x_m - x(p);
            R(10,index(10,1),2) = y_m - y(p);
            index(10,1) = index(10,1) + 1;
        else
            R(angle,index(angle,1),1)=  x_m - x(p);
            R(angle,index(angle,1),2) = y_m - y(p);
            index(angle,1) = index(angle,1) + 1;
        end
    end

    %% Image
    % object detection in "im" image
    im = rgb2gray(im);
    im = edge(im,'canny');
    % figure, imshow(im);
    
    [xi,yi] = find(im>0); 
    
    %accumulator table
    acc = zeros(size(imInitial));

    Dy = imfilter(double(im),[1; -1],'same');
    Dx = imfilter(double(im),[1  -1],'same');
    I = mod(radtodeg(atan2(Dy,Dx))+180, 180);

    for p = 1:size(xi)
        angle = ceil(I(xi(p),yi(p))/20);
        if angle == 0
            angle = 10;
        end
        for c = 1:index(angle,1)
            xc = xi(p)+R(angle,c,1);
            yc = yi(p)+R(angle,c,2);
            if xc <= size(acc,1) && yc <= size(acc,2)&&xc>=1&&yc>=1
                acc(xc,yc) = acc(xc,yc)+1;
            end
        end
    end

    [~, max_idx] = max(acc(:));
    [row,col] = ind2sub(size(acc),max_idx);
    
    disp(row);
    disp(col);
    out = zeros(size(imInitial,1),size(imInitial,2));
    for angle = 1:10
        for t = 1:index(angle,1)
            r = min(row - R(angle,t,1),size(out,1));
            c = min(col - R(angle,t,2),size(out,2));
            out(r,c)=1;
        end
    end
    for r = 1:size(out,1)
        i = 1;
        while i<=size(out,2)&&out(r,i)~=1
            i = i + 1;
        end
        j=size(out,2);
        while j>=1&&out(r,j)~=1
            j=j-1;
        end
        if j>i
            for ind = i:j
            out(r,ind)=1;
            end
        end
    end
    mask = 1-out;