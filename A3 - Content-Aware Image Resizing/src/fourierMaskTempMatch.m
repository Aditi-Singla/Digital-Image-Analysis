function [mask, maxpt] = fourierMaskTempMatch(im, temp)
    
    % Padding temp with zeros
    temp1 = zeros([size(im,1),size(im,2)]);
    temp1(1:size(temp,1),1:size(temp,2)) = temp(:,:,1);
%     temp1 = imdilate(temp1,strel('disk',3));
    S1 = fftshift(fft2(im(:,:,1)));
    S2 = fftshift(fft2(temp1));
    convolved = S1 .* conj(S2);
    convolvedNorm = convolved./abs(convolved);
    IFT = ifft2(fftshift(convolvedNorm));
    plot(IFT);
    minimum = min(real(IFT(:)));
    disp(minimum);
    maximum = max(real(IFT(:)));
    disp(maximum);
    IFT1 = (IFT - minimum);
    IFT1 = real(IFT1)/(maximum - minimum);
    disp(size(IFT1));
    IFT = IFT1;
    figure, imshow(IFT1);
    % Find the maximum value & find pixel position of the maximum value
    maxpt = max(real(IFT(:)));
    [x,y] = find(real(IFT) == maxpt);
    
    temp1 = rgb2gray(temp);
    temp1 = edge(temp1,'canny');
    temp1 = imdilate(temp1,strel('disk',3));
    imwrite(temp1,'cannyedge.png');
    figure, imshow(temp1);
    
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
            mask(x+i-1,y+j-1) = out(i,j);
        end
    end
    
    im1 = im;
    for z = 1:size(im,3)
        for j = y+1:y+size(temp,2)
            for i = x+1:x+size(temp,1)
                if (out(i-x,j-y)==0)
                    im1(i,j,z) = 0;
                end;    
            end;    
        end;    
    end;
    figure, imshow(im1);
    imwrite(im1,'cutout.png');