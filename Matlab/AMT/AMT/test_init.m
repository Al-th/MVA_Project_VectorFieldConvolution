clear;
clc;
[Fx,Fy] = getKernel(128,1,1.7);
alpha = .8;
beta = 0.1;
tau = 0.5;
RES = 0.5;
C = zeros(2);
C(1) = 125;
C(2) = 125;
R = 80;
imName = 'star.png';
downsampleFactor = 4;
edgeMapType = 'image';
fextType = 'vfc';
typeTest = 'vfc - star - centered large';

%%

clear;
clc;
[Fx,Fy] = getKernel(128,1,1.7);
alpha = .8;
beta = 0.1;
tau = 0.5;
RES = 0.5;
C = zeros(2);
C(1) = 125;
C(2) = 110;
R = 20;
imName = 'star.png';
downsampleFactor = 4;
edgeMapType = 'image';
fextType = 'vfc';
typeTest = 'vfc - star - centered small';

%%


clear;
clc;
[Fx,Fy] = getKernel(128,1,1.7);
alpha = .8;
beta = 0.1;
tau = 0.5;
RES = 0.5;
C = zeros(2);
C(1) = 140;
C(2) = 110;
R = 20;
imName = 'star.png';
downsampleFactor = 4;
edgeMapType = 'image';
fextType = 'vfc';
typeTest = 'vfc - star - uncentered small';

%%
clear;
clc;
[Fx,Fy] = getKernel(128,1,1.7);
alpha = .8;
beta = 0.1;
tau = 0.5;
RES = 0.5;
C = zeros(2);
C(1) = 150;
C(2) = 110;
R = 120;
imName = 'star.png';
downsampleFactor = 4;
edgeMapType = 'image';
fextType = 'vfc';
typeTest = 'vfc - star - uncentered big';

%%
clear;
clc;
[Fx,Fy] = getKernel(128,1,1.7);
alpha = .8;
beta = 0.1;
tau = 0.5;
RES = 0.5;
C = zeros(2);
C(1) = 170;
C(2) = 110;
R = 60;
imName = 'star.png';
downsampleFactor = 4;
edgeMapType = 'image';
fextType = 'vfc';
typeTest = 'vfc - star - unsym';


%%


I = imread(imName);
if(size(I,3) == 3)
   I = rgb2gray(I); 
end

I = double(I);
f = downsample2d(I,downsampleFactor);

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
    imNameSave = ['OutputImageInitialisation/' typeTest num2str(i)];
    set(gca,'position',[0 0 1 1],'units','normalized')
    print(imNameSave,'-dpng');
    pause(0.1);
end