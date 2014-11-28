function EdgeMap = getEdgeMap(image,type)

if strcmp(type,'image')
    EdgeMap = image;
else if strcmp(type,'sobelMagnitude')
        
    SobelX = [-1,0,1;-2,0,2;-1,0,1];
    SobelY = [-1,-2,-1;0,0,0;1,2,1];

    Gx = conv2(image,SobelX);
    Gx = Gx(2:end-1,2:end-1);
    Gy = conv2(image,SobelY);
    Gy = Gy(2:end-1,2:end-1);

    EdgeMap = sqrt(Gx.*Gx+Gy.*Gy);
    
    else if strcmp(type,'cannyWeighted')
            SobelX = [-1,0,1;-2,0,2;-1,0,1];
    SobelY = [-1,-2,-1;0,0,0;1,2,1];

    Gx = conv2(image,SobelX);
    Gx = Gx(2:end-1,2:end-1);
    Gy = conv2(image,SobelY);
    Gy = Gy(2:end-1,2:end-1);

    EdgeMap = sqrt(Gx.*Gx+Gy.*Gy);
    
    EdgeMap =  EdgeMap .* edge(image,'canny');
        end
    end
end
EdgeMap(1,:) = 0;
EdgeMap(end,:) = 0;
EdgeMap(:,1) = 0;
EdgeMap(:,end) = 0;
end