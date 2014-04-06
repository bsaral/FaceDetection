clear all;

sdir = 'DB';
jpegs = dir([sdir '/*.jpg']);
i = 0;

for j = 1:length(jpegs)
    f = [sdir '/' jpegs(j).name];
     rgbInputImage = imread(f);
    img = increaseBrightness(rgbInputImage);
    [final_image,counter_skin] = colorRGB_YCbCr(img);

    counter_total = size(img,1) * size(img,2);
    counter_perim = 1;
    valid_size = 500;
    binaryImage=im2bw(final_image,0.1);                  
    binaryImage = imfill(binaryImage,'holes');            

    for k=1:counter_perim                                 
        binaryImage1 = bwperim(binaryImage,8);            
        binaryImage = binaryImage - binaryImage1;
        figure, imshow(binaryImage);
    end
    
    binaryImage = bwareaopen(binaryImage,valid_size);   
    labeledImage = bwlabel(binaryImage, 8);              
    blobMeasurements = regionprops(labeledImage, final_image, 'all');
    numberOfPeople = size(blobMeasurements, 1);
    imagesc(rgbInputImage);                           
    hold on;
    
    for k = 1 : numberOfPeople
        thisBlobsBox = blobMeasurements(k).BoundingBox;
        ecen = blobMeasurements(k).Eccentricity;
        x1 = thisBlobsBox(1);
        y1 = thisBlobsBox(2);
        x2 = x1 + thisBlobsBox(3);
        y2 = y1 + thisBlobsBox(4);
        a = thisBlobsBox(3) / thisBlobsBox(4);
        x = [x1 x2 x2 x1 x1];
        y = [y1 y1 y2 y2 y1];
    
         if((ecen > 0.25) && (ecen < 0.97) && (a < 2.0) &&( a > 0.3) )
                  plot(x, y, 'LineWidth', 2);  
        end
    end
end
