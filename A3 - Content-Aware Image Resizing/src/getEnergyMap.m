function acc = getEnergyMap(mag)
    
    [dy, dx] = gradient(mag); % Gradient Energy Function
    acc = hypot(dy,dx);
    
%     HOG = extractHOGFeatures(mag); % HOG Energy Map
%     acc = mag/max(HOG);

%     acc = entropyfilt(mag); % Entropy Energy Map