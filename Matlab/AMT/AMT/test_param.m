clear;
clc;
alpha = .5;
beta = 0.1;
tau = 0.5;
eps = 0.01;
imName = 'test.jpg';
downsampleFactor = 1;
edgeMapType = 'cannyWeighted';

%%
% Plot m1 profile w.r.t to gamma
x = 0:0.01:16;
figure(1);
hold on
gammaRange = 0.5:0.5:3;
colors = colormap(hsv(length(gammaRange)));
for gamma=gammaRange,
    y = 1./(x+eps).^gamma;
    h(gamma*2) = plot(x,y,'Color',colors(gamma*2,:),...
        'DisplayName',sprintf('gamma=%.2f',gamma));
    ylim([0,3]);
end
legend(h);
hold off

%%
% Plot m2 profile w.r.t to sigma
x = 0:0.01:16;
figure(2);
hold on
sigmaRange = 0.5:0.5:5;
colors = colormap(hsv(length(sigmaRange)));
for sigma=sigmaRange,
    y = exp(-x.^2/sigma^2);
    h(sigma*2) = plot(x,y,'Color',colors(sigma*2,:),...
        'DisplayName',sprintf('sigma=%.2f',sigma));
end
legend(h);
hold off

%%
% Study the evolution of capture range w.r.t gamma
% See test_nico.m and modify gamma to see the streamline evolution
% load images
im = imread('synthetic_edge_map.png');
f = double(im(:,:,1));
[n,m] = size(f);
f = (255*ones(n,m)-f);
im_gt = imread('gt_synthetic_edge_map.png');
f_gt = double(im_gt(:,:,1));
f_gt = (255*ones(n,m)-f_gt);


for gamma=0.5:0.5:3
%Compute convolution kernel
[Fx,Fy] = getKernel(128,1,gamma);
K(:,:,1) = Fx;
K(:,:,2) = Fy;
%Compute Fext
Fext = AM_VFC(f,K);
% Normalize
Fmag = sqrt(sum(Fext.*Fext,3))+eps;
Fext(:,:,1) = Fext(:,:,1)./Fmag;
Fext(:,:,2) = Fext(:,:,2)./Fmag;

figure(3);
plot_streamline(300,4,Fext,(255*ones(n,m)-f),f_gt);
pause(2);
clear K; clear Fext; clear Fx; clear Fy;
end

%%
% Study the evolution of capture range w.r.t to R (radius of kernel
% convolution)

for k=3:8
%Compute convolution kernel
kernelRadius = 2.^k;
[Fx,Fy] = getKernel(kernelRadius,1,1.7);
K(:,:,1) = Fx;
K(:,:,2) = Fy;
%Compute Fext
Fext = AM_VFC(f,K);
% Normalize
Fmag = sqrt(sum(Fext.*Fext,3))+eps;
Fext(:,:,1) = Fext(:,:,1)./Fmag;
Fext(:,:,2) = Fext(:,:,2)./Fmag;

figure(4);
plot_streamline(300,4,Fext,(255*ones(n,m)-f),f_gt);

clear K; clear Fext; clear Fx; clear Fy;
end


%%
% Study the evolution of the VFC field for m2 magnitude w.r.t sigma
% Sigma must be initialized according to the radius of kernel 

for sigma=20:25
%Compute convolution kernel
[Fx,Fy] = getKernel(128,2,sigma);
K(:,:,1) = Fx;
K(:,:,2) = Fy;
%Compute Fext
Fext = AM_VFC(f,K);
% Normalize
Fmag = sqrt(sum(Fext.*Fext,3))+eps;
Fext(:,:,1) = Fext(:,:,1)./Fmag;
Fext(:,:,2) = Fext(:,:,2)./Fmag;

figure(5);
plot_streamline(300,4,Fext,(255*ones(n,m)-f),f_gt);
pause(2);
clear K; clear Fext; clear Fx; clear Fy;
end
