function [Fx,Fy] = getKernel(kernelRadius,type);
kernelRadius = 32;
[X,Y] = meshgrid(-kernelRadius:1:kernelRadius, -kernelRadius:1:kernelRadius);

r = sqrt(X.^2+Y.^2);
S = size(X);


if (type==1)
    epsilon = 1e-8;
    gamma = 1.9;
    forceMagnitude = (r+epsilon).^(-gamma);
else
    sigma = 4;  
    forceMagnitude = exp(-r.^2/sigma^2);
end

nx = [-X./r];
ny = [-Y./r];

nx(kernelRadius+1,kernelRadius+1) = 0;
ny(kernelRadius+1,kernelRadius+1) = 0;

Fx = forceMagnitude.*nx;
Fy = forceMagnitude.*ny;
end