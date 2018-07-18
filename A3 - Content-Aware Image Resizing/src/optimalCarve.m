function finalImage = optimalCarve(img, diffRows, diffCols)
    
    T = zeros(diffRows+1, diffCols+1);
    I = cell(diffRows+1, diffCols+1);
    B = zeros(diffRows+1, diffCols+1);

    for i = 0:diffRows
        for j = 0:diffCols
            if (i == 0)
                if (j == 0)
                    B(i+1,j+1) = 0;
                    T(i+1,j+1) = 0;
                    I{i+1,j+1} = img;             
                else
                    B(i+1,j+1) = 0;
                    IVert = I{i+1,j};
                    [n,~,~] = size(IVert);
                    E = accMinVertPathMap(IVert);
                    v = findVertSeam(E);
                    [~, minCol] = min(E(n,:));
                    T(i+1,j+1) = T(i+1,j) + E(n,minCol);
                    I{i+1,j+1} = vertSeamCarve(IVert,v);   
                end
            else
                if (j == 0)
                    B(i+1,j+1) = 1;
                    IHoriz = I{i,j+1};
                    [~,m,~] = size(IHoriz);
                    E = accMinHorizPathMap(IHoriz);
                    h = findHorizSeam(E);
                    [~, minRow] = min(E(:,m));
                    T(i+1,j+1) = T(i,j+1) + E(minRow,m);
                    I{i+1,j+1} = horizSeamCarve(IHoriz, h);
                else
                    IHoriz = I{i,j+1};
                    [~,m,~] = size(IHoriz);
                    EHoriz = accMinHorizPathMap(IHoriz);
                    [~, minRow] = min(EHoriz(:,m));
                    eHoriz = EHoriz(minRow,m);
                    
                    IVert = I{i+1,j};
                    [n,~,~] = size(IVert);
                    EVert = accMinVertPathMap(IVert);
                    [~, minCol] = min(EVert(n,:));
                    eVert = EVert(n,minCol);
                    
                    if ((T(i,j+1)+eHoriz) < (T(i+1,j)+eVert))
                        B(i+1,j+1) = 1;
                        h = findHorizSeam(EHoriz);
                        T(i+1,j+1) = T(i,j+1)+eHoriz;
                        I{i+1,j+1} = horizSeamCarve(IHoriz, h);
                    else
                        B(i+1,j+1) = 0;
                        v = findVertSeam(EVert);
                        T(i+1,j+1) = T(i+1,j)+eVert;
                        I{i+1,j+1} = vertSeamCarve(IVert,v);
                    end
                end
            end
        end
    end
    finalImage = I{diffRows+1,diffCols+1};