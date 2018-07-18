function acc = accMinHorizPathMap(img)
    
    mag = rgb2gray(img);
    [dimY,dimX] = size(mag);
    mag = getEnergyMap(mag);
    acc = mag;
    
    for x=2:dimX
        for y=1:dimY
            if (y == 1)
                acc(y,x) = mag(y,x) + min([acc(y,x-1), acc(y+1,x-1)]);
            elseif (y == dimY)
                acc(y,x) = mag(y,x) + min([acc(y,x-1), acc(y-1,x-1)]);
            else
                acc(y,x) = mag(y,x) + min([acc(y-1,x-1), acc(y,x-1), acc(y+1,x-1)]);
            end;
        end;
    end;    