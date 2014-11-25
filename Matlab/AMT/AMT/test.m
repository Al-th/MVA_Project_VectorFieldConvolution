clear;
clc;
[Fx,Fy] = getKernel(32,1);
alpha = .5;
beta = 0.1;
tau = 0.5;
RES = 0.5;
R = 100;
imName = 'im_Unoisy.bmp';
downsampleFactor = 1;
edgeMapType = 'sobelMagnitude';

%%

I = imread(imName);
I = downsample2d(I,downsampleFactor);
f = double(I);
I = downsample2d(I,downsampleFactor);

EdgeMap = getEdgeMap(f,'cannyWeighted');

imshow(EdgeMap,[min(min(EdgeMap)),max(max(EdgeMap))]);
pause();


[Fext] = getFext(Fx,Fy,EdgeMap);



I = I-(min(min(I)));
I = I./(max(max(I)));

vt = AC_initial(RES, 'circle', [70 70 R]);   % seeds
for i=1:100, % moving these seeds
    vt  = AC_deform(vt,alpha,beta,tau,Fext,10);
    vt = AC_remesh(vt,1);
    
    AC_quiver(Fext,I);
    hold on;
    plot(vt(:,1),vt(:,2),'.r');
    hold off
    pause(0.1);
end

