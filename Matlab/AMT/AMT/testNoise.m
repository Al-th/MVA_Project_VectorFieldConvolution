clear;
clc;
[Fx,Fy] = getKernel(64,1,1.7);
alpha = .8;
beta = 0.1;
tau = 0.5;
RES = 0.5;
C = zeros(2);
C(1) = 115;
C(2) = 115;
R = 120;
imName = 'star.png';
downsampleFactor = 4;
edgeMapType = 'image';
fextType = 'vfc';
typeTest = 'vfc - star - gaussian -smallerkernel';

noiseType = 'gaussian';
param = 0.05;

%%
clear;
clc;
[Fx,Fy] = getKernel(128,1,1.7);
alpha = .8;
beta = 0.1;
tau = 0.5;
RES = 0.5;
C = zeros(2);
C(1) = 115;
C(2) = 115;
R = 120;
imName = 'star.png';
downsampleFactor = 4;
edgeMapType = 'image';
fextType = 'vfc';
typeTest = 'vfc - star - salt pepper';

noiseType = 'salt & pepper';
param = 0.15;
%%
clear;
clc;
alpha = .8;
beta = 0.1;
tau = 0.5;
RES = 0.5;
C = zeros(2);
C(1) = 100;
C(2) = 100;
R = 80;
imName = 'star.png';
downsampleFactor = 4;
edgeMapType = 'image';
fextType = 'gvf';
mu = .2;
GVF_ITER = 10000;
normalize = 1;
typeTest = 'GVF - star';

noiseType = 'salt & pepper';
param = 0.05;

%%


I = imread(imName);
if(size(I,3) == 3)
   I = rgb2gray(I); 
end

I = double(I);
f = downsample2d(I,downsampleFactor);

f = imnoise(f,noiseType,param);

edgeMap = getEdgeMap(f,edgeMapType);


if strcmp(fextType,'vfc')
    Fext = getFext(Fx,Fy,edgeMap);
else if strcmp(fextType,'gvf')
        Fext = AM_GVF(edgeMap,mu, GVF_ITER, normalize);
    end
end


% imshow(edgeMap,[min(min(edgeMap)),max(max(edgeMap))]);
% hold on;
% AC_quiver(Fext,edgeMap);
% hold off;
% pause();

    
f = f-(min(min(f)));
f = f./(max(max(f)));

if 0
    [x,y] = ginput(2);
    C(1) = x(1);
    C(2) = y(1);

    R = sqrt((x(2)-x(1))^2+(y(1)-y(2))^2)
end

vt = AC_initial(RES, 'circle', [C(1) C(2) R]);   % seeds
for i=1:100, % moving these seeds
    vt  = AC_deform(vt,alpha,beta,tau,Fext,5);
    vt = AC_remesh(vt,1);
    
    imshow(edgeMap,[min(min(edgeMap)) max(max(edgeMap))]);
    hold on;
    plot(vt(:,1),vt(:,2),'.r');
    hold off
    imName = ['OutputImagesNoise/' typeTest ' - ' num2str(param*100) ' - ' num2str(i)];
    print(imName,'-dpng');
    pause(0.1);
end

figure()
plot_streamline(2000,5,Fext,edgeMap,downsample2d(I,downsampleFactor))
imName = ['OutputImagesNoise/' typeTest ' - ' num2str(param*100) ' - streamLines'];
print(imName,'-dpng');

