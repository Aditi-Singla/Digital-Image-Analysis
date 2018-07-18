function resizeImage(img)
    
    figure, imshow(img);
    [rows, cols, ~] = size(img);
    fprintf('Current Size of image : %d, %d.\n', rows, cols);
    rows1 = input('New number of rows: ');
    cols1 = input('New number of cols: ');
    
    newRows = rows1 - rows;
    newCols = cols1 - cols;
    
    if newRows > 0 || newCols > 0
        if newRows > 0
            carved = insertHorizSeams(img, newRows);
            figure, imshow(carved);
            if newCols > 0
                carved = insertVertSeams(carved, newCols);
                figure, imshow(carved);
                imwrite(carved,'final.jpg');
            elseif newCols < 0
                carved = carveVertSeams(carved, -newCols);
                figure, imshow(carved);
                imwrite(carved,'final.jpg');
            else
                imwrite(carved,'final.jpg');
            end    
        elseif newCols > 0
            carved = insertVertSeams(img, newCols);
            figure, imshow(carved);
            if newRows < 0
                carved = carveHorizSeams(carved, -newRows);
                figure, imshow(carved);
                imwrite(carved,'final.jpg');
            else
                imwrite(carved,'final.jpg');
            end  
        end
    else
        if newRows == 0
            if newCols == 0
                figure, imshow(img);
            else
                carved = carveVertSeams(img, -newCols);
                figure, imshow(carved);
                imwrite(carved,'final.jpg');
            end
        else
            if newCols == 0
                carved = carveHorizSeams(img, -newRows);
                figure, imshow(carved);
                imwrite(carved,'final.jpg');
            else
                carved = optimalCarve(img,-newRows,-newCols);
                figure, imshow(carved);
                imwrite(carved,'final.jpg');
            end
        end
    end