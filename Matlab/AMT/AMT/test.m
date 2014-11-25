clear;
clc;
[Fx,Fy] = getKernel(32,1);
alpha = .5;
beta = 0.1;
tau = 0.5;
RES = 0.5;
C = zeros(2);
C(1) = 80;
C(2) = 80;
R = 70;
imName = 'im_Unoisy.bmp';
downsampleFactor = 1;
edgeMapType = 'cannyWeighted';

%%

I = imread(imName);
I = downsample2d(I,downsampleFactor);
f = double(I);

edgeMap = getEdgeMap(f,edgeMapType);

imshow(edgeMap,[min(min(edgeMap)),max(max(edgeMap))]);
pause();

Fext = getFext(Fx,Fy,edgeMap);

f = f-(min(min(f)));
f = f./(max(max(f)));

if 1
    print('click in window for center and radius of circle')
    [x,y] = ginput(2);
    C(1) = x(1);
    C(2) = y(1);

    R = sqrt((x(2)-x(1))^2+(y(1)-y(2))^2)
end

vt = AC_initial(RES, 'circle', [C(1) C(2) R]);   % seeds
for i=1:100, % moving these seeds
    vt  = AC_deform(vt,alpha,beta,tau,Fext,10);
    vt = AC_remesh(vt,1);
    
    imshow(edgeMap,[min(min(edgeMap)) max(max(edgeMap))]);
    hold on;
    plot(vt(:,1),vt(:,2),'.r');
    hold off
    pause(0.1);
end

