function face = enhanceFace(rgbImg)
    figure, imshow(rgbImg);
    title('Face Input');
    
    %Face Detection
    FDetect = vision.CascadeObjectDetector;
    BB = step(FDetect,rgbImg);

%     figure, imshow(rgbImg);
%     hold on
%     for i = 1:size(BB,1)
%         rectangle('Position',BB(i,:),'LineWidth',1,'LineStyle','-','EdgeColor','r');
%     end
%     title('Face Detection');
%     hold off;

    %Obtain the base and detail for greyscale
    YCbCr = rgb2ycbcr(rgbImg);
    Y = YCbCr(:,:,1);
    Cb = YCbCr(:,:,2); 
    Cr= YCbCr(:,:,3);

    greyImg = double(Y);
    greyImg = greyImg./max(greyImg(:));
    base = wlsFilter(greyImg);
    detail = imsubtract(greyImg,base);
%     figure, imshow(greyImg);
%     figure, imshow(base);
%     figure, imshow(detail);
    
    out = base;
    fprintf('Number of faces = %f\n',size(BB,1));
    for loop = 1:size(BB,1)
        %Skinmask
        cform = makecform('srgb2lab');
        J = applycform(rgbImg,cform);
        L = graythresh(J(:,:,2));
        skinmask = im2bw(J(:,:,2),L);
        skinmask = imcrop(skinmask, BB(loop,:));
       
        F = imcrop(out,BB(loop,:));
        S = min(F,skinmask);
        %figure, imshow(S);

        %Smoothed Histogram
        [count,x] = imhist(S);
        x = x(10:end);
        count = count(10:end);
        count1 = smooth(count);
%         figure, stem(x,count1);
%         figure, imhist(S);

        [sortcount, sortIndex] = sort(count1,'descend');
        sortx = x(sortIndex);

        max1 = sortcount(1);
        max1index = sortIndex(1);
        m = 1;
        d = 0;
        b = 1;
        s = 0;
        counter = max1;
        for i = 2 : size(x)
            max2 = sortcount(i);
            max2index = sortIndex(i);
            for j = max1index : max2index
                if count1(j) <= 0.8*(min(max1,max2))
                    if s == 0
                        s = 1;
                        m = x(j);
                        counter = count1(j);
                    else
                        if (counter > count1(j))
                            counter = count1(j); 
                            m = x(j);
                        end
                    end
                end
            end   
            if s==1
                d = min(sortx(1),sortx(i));
                b = max(sortx(1),sortx(i));
                break;
            end
        end
        
        if s == 1
            f = (b-d)/(m-d);
            f = max(1,f);
            f = min(1.5,f);
%             fprintf('m = %f\n', m);  
%             fprintf('d = %f\n', d);  
%             fprintf('b = %f\n', b);  
%             fprintf('f = %f\n', f);  
            A = out;
            mask = zeros(size(out));
            for i = BB(loop,2):BB(loop,2)+BB(loop,4)
                for j = BB(loop,1):BB(loop,1)+BB(loop,3)
                    if (A(i,j) < m)
                        A(i,j) = A(i,j)*f;
                        mask(i,j) = 255;
                    end
                end
            end
            out = im2uint8(out);
            A = im2uint8(A);
            mask = im2uint8(mask);
            %figure, imshow(cat(3,out,out,out));
            %figure, imshow(cat(3,A,A,A));
            %figure, imshow(cat(3,mask,mask,mask));
            out1 = LaplacianBlend(cat(3,out,out,out), cat(3,A,A,A), cat(3,mask,mask,mask));
            out1 = LaplacianBlend(cat(3,out,out,out), out1, cat(3,mask,mask,mask));
            out1 = LaplacianBlend(cat(3,out,out,out), out1, cat(3,mask,mask,mask));
            out1 = LaplacianBlend(cat(3,out,out,out), out1, cat(3,mask,mask,mask));
            out = out1(:,:,1);
            %figure, imshow(out);
            %title('out sidelit');
        end

        p = prctile(reshape(S,1,[]),75);
        p = p*255;
        fprintf('p = %f\n', p);
        if p < 120
            f = (120+p)/(2*p);
            f = max(1,f);
            f = min(2,f);
            A = out;
            mask = zeros(size(out(:,:,1)));
            for i = BB(loop,2):BB(loop,2)+BB(loop,4)
                for j = BB(loop,1):BB(loop,1)+BB(loop,3)
                    A(i,j) = A(i,j)*f;
                    mask(i,j) = 255;    
                end
            end
            out = im2uint8(out);
            A = im2uint8(A);
            mask = im2uint8(mask);
            %figure, imshow(cat(3,out,out,out));
            %figure, imshow(cat(3,A,A,A));
            %figure, imshow(cat(3,mask,mask,mask));
            out1 = LaplacianBlend(cat(3,out,out,out), cat(3,A,A,A), cat(3,mask,mask,mask));
            out1 = LaplacianBlend(cat(3,out,out,out), out1, cat(3,mask,mask,mask));
            out1 = LaplacianBlend(cat(3,out,out,out), out1, cat(3,mask,mask,mask));
            out1 = LaplacianBlend(cat(3,out,out,out), out1, cat(3,mask,mask,mask));
            out = out1(:,:,1);
            %figure,imshow(out1);
            %title('out exposure');
        end    

        out = im2double(out);
        out = imadd(out,detail);
        %figure, imshow(out);
        %title('final output');
    end

    out = im2uint8(out);
    combinedImg = cat(3,out,Cb,Cr);
    face = ycbcr2rgb(combinedImg);

    figure, imshow(face);
    title('Face Output');
end