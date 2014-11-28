function [Fx,Fy] = getKernel(kernelRadius,type, param);

[X,Y] = meshgrid(-kernelRadius:1:kernelRadius, -kernelRadius:1:kernelRadius);

r = sqrt(X.^2+Y.^2);
S = size(X);


if (type==1)
    epsilon = 1e-8;
    gamma = param;
    forceMagnitude = (r+epsilon).^(-gamma);
else
    sigma = param;  
    forceMagnitude = exp(-r.^2/sigma^2);
end

nx = [-X./r];
ny = [-Y./r];

nx(kernelRadius+1,kernelRadius+1) = 0;
ny(kernelRadius+1,kernelRadius+1) = 0;

Fx = forceMagnitude.*nx;
Fy = forceMagnitude.*ny;

end