function seamsModified = modifyOrder(seams)
    [dimY, n] = size(seams);
    for y = 1:dimY
        for x = 1:n
            disp(x);
            u = seams(y,x);
            l = 0;
            b = true;
            while (b)
                c = 0;
                for i = 1:x-1
                    if (seams(y,i) <= u && seams(y,i) > l)
                        c = c + 1;
                    end;
                end;
                if (c == 0)
                    seams(y,x) = u;
                    b = false;
                else
                    l = u;
                    u = u + c;
                end;    
            end;    
        end;    
    end;
    seamsModified = seams;