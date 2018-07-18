function finalMap = accMinVertPathMap(img)

    energymap = rgb2gray(img);
    [dimY,dimX] = size(energymap);
    energymap = getEnergyMap(energymap);
    finalMap = energymap;
    
    for y=2:dimY
    for x=1:dimX
        if (x == 1)
            finalMap(y,x) = energymap(y,x) + min([finalMap(y-1,x), finalMap(y-1,x+1)]);
        elseif (x == dimX) 
            finalMap(y,x) = energymap(y,x) + min([finalMap(y-1,x), finalMap(y-1,x-1)]);
        else
            finalMap(y,x) = energymap(y,x) + min([finalMap(y-1,x-1), finalMap(y-1,x), finalMap(y-1,x+1)]);
        end;
    end;
    end;    