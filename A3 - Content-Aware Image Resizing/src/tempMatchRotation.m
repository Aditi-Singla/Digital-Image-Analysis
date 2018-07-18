function mask = tempMatchRotation(im, temp)
    
    maxScore = 0;
    x1 = 0;
    y1 = 0;
    i1 = 0;
    for i = -180:10:180
        temp1 = rotateImage(temp, i);
        [score, x, y] = fourierTempMatch(im,temp1);
        if score > maxScore
            x1 = x;
            y1 = y;
            maxScore = score;
            i1 = i;
        end
    end
    disp(maxScore);
    
    temp = rotateImage(temp, i1);
    temp1 = rgb2gray(temp);
    temp1 = edge(temp1,'canny');
    temp1 = imdilate(temp1,strel('disk',3));
    
    out = 1-temp1;
    for r = 1:size(out,1)
        i = 1;
        while i<=size(out,2)&&out(r,i)~=0
            i = i + 1;
        end
        j=size(out,2);
        while j>=1&&out(r,j)~=0
            j=j-1;
        end
        if j>i
            for ind = i:j
            out(r,ind)=0;
            end
        end
    end
    mask = ones(size(im,1),size(im,2));
    for i = 1:size(out,1)
        for j = 1:size(out,2)
            mask(x1+i-1,y1+j-1) = out(i,j);
        end
    end