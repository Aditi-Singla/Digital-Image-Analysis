function [maxpt, x, y] = fourierTempMatch(im, temp)
    
    % Padding temp with zeros
    temp1 = zeros([size(im,1),size(im,2)]);
    temp1(1:size(temp,1),1:size(temp,2)) = temp(:,:,1);
    temp1 = imdilate(temp1,strel('disk',3));
    
    % Fourier Transform
    Signal1 = fftshift(fft2(im(:,:,1)));
    Signal2 = fftshift(fft2(temp1));

    % Mulitplication of Signal1 with the conjugate of Signal2
    convolved = Signal1 .* conj(Signal2);
    convolvedNorm = convolved./abs(convolved);

    % Application of inverse fourier transform
    IFT = ifft2(fftshift(convolvedNorm));

    % Find the maximum value & find pixel position of the maximum value
    maxpt = max(real(IFT(:)));
    [x,y] = find(real(IFT) == maxpt);