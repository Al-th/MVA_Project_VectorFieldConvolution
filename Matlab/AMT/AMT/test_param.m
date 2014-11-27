clear;
clc;
[Fx,Fy] = getKernel(32,1);
alpha = .5;
beta = 0.1;
tau = 0.5;
eps = 0.01;
imName = 'test.jpg';
downsampleFactor = 1;
edgeMapType = 'cannyWeighted';

%%
% Plot gamma profile for m1 magnitude
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
% Study the evolution of capture range w.r.t gamma
% See test_nico.m and modify gamma to see the streamline evolution


%%
% Study the evolution of capture range w.r.t to R (radius of kernel
% convolution)

% load images
im = imread('synthetic_edge_map.png');
f = double(im(:,:,1));
[n,m] = size(f);
f = (255*ones(n,m)-f);
im_gt = imread('gt_synthetic_edge_map.png');
f_gt = double(im_gt(:,:,1));
f_gt = (255*ones(n,m)-f_gt);

%Compute Fext
K = AM_VFK(2, 32, 'power',1.7);
Fext = AM_VFC(f,K);
% Normalize
Fmag = sqrt(sum(Fext.*Fext,3))+eps;
Fext(:,:,1) = Fext(:,:,1)./Fmag;
Fext(:,:,2) = Fext(:,:,2)./Fmag;

figure(2);
plot_streamline(300,4,Fext,f,f_gt);
