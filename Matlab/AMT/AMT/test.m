clear;
clc;

[Fx,Fy] = getKernel(32,1);

alpha = .5;
beta = 0.1;
tau = 0.5;
RES = 0.5;
R = 100;
vt = AC_initial(RES, 'circle', [70 70 R]);   % seeds

[Fext,resizedIm] = getFext(Fx,Fy,'im_lung.png',2);
s = size(Fext);
[x_im,y_im] = meshgrid(1:s(2),1:s(1));

I = imread('im_lung.png');
I = double(I);
I = downsample2d(I,2);
I = I-(min(min(I)));
I = I./(max(max(I)));

for i=1:100, % moving these seeds
    vt  = AC_deform(vt,alpha,beta,tau,Fext,5);
    vt = AC_remesh(vt,1);
    
    AC_quiver(Fext,I);
    hold on;
    plot(vt(:,1),vt(:,2),'.r');
    hold off
    pause(0.1);
end

