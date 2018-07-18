function finalMap = accMinHorizPathMapMask(img, mask)
    
    energymap = rgb2gray(img);
    [dimY,dimX] = size(energymap);
    energymap = getEnergyMap(energymap);
    
    [m,n] = size(mask);
    for i = 1:m
        for j = 1:n
            if (mask(i,j) == 0)
                energymap(i,j) = -1000;
            end;
        end;
    end;
    finalMap = energymap;
    
    for x = 2:dimX
        for y = 1:dimY
            if (y == 1)
                finalMap(y,x) = energymap(y,x) + min([finalMap(y,x-1), finalMap(y+1,x-1)]);
            elseif (y == dimY)
                finalMap(y,x) = energymap(y,x) + min([finalMap(y,x-1), finalMap(y-1,x-1)]);
            else
                finalMap(y,x) = energymap(y,x) + min([finalMap(y-1,x-1), finalMap(y,x-1), finalMap(y+1,x-1)]);
            end;
        end;
    end;