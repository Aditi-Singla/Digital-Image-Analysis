function getLandmarkPoints(imgRefFilename, imgOrigFilename, lmFilename)
    
    img1In = imread(imgRefFilename);
    img2In = imread(imgOrigFilename);

    NPs = input('Enter number of landmark points : ');

    figure(2);
    Hp=subplot(1,2,1); % for landmark point selection
    image(img1In);
    hold on;

    Hs=subplot(1,2,2); % for correspondence point selection
    imagesc(img2In);
    hold on;

    Xp=[]; Yp=[]; Xs=[]; Ys=[];
    for ix = 1:NPs
        axis(Hp);
        [Yp(ix),Xp(ix)]=ginput(1); % get the landmark point
        scatter(Yp(ix),Xp(ix),32,'y','o','filled'); % display the point
        text(Yp(ix),Xp(ix),num2str(ix),'FontSize',6);

        axis(Hs);
        [Ys(ix),Xs(ix)]=ginput(1); % get the corresponding point
        scatter(Ys(ix),Xs(ix),32,'y','*'); % display the point
        text(Ys(ix),Xs(ix),num2str(ix),'FontSize',6);
    end
    
    fileName = strcat(imgRefFilename,'.txt');
    fid = fopen(fileName, 'w');
    for row = 1:NPs
        fprintf(fid, '%.1f ', Yp(row));
        fprintf(fid, '%.1f\n', Xp(row));
    end
    fclose(fid);
    fileName = strcat(imgOrigFilename,'.txt');
    fid = fopen(fileName, 'w');
    for row = 1:NPs
        fprintf(fid, '%.1f ', Ys(row));
        fprintf(fid, '%.1f\n', Xs(row));
    end
    fclose(fid);
    save(lmFilename,'Xp','Yp','Xs','Ys');
return;