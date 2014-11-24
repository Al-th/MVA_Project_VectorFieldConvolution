function [Fext, noisyU] = getFext(Fx,Fy, imName,downscaleFactor);
noisyU = imread(imName);
noisyU = downsample2d(noisyU,downscaleFactor);
f = double(noisyU);

SobelX = [-1,0,1;-2,0,2;-1,0,1];
SobelY = [-1,-2,-1;0,0,0;1,2,1];

Gx = conv2(f,SobelX);
Gx = Gx(2:end-1,2:end-1);
Gy = conv2(f,SobelY);
Gy = Gy(2:end-1,2:end-1);

Eext = sqrt(Gx.*Gx+Gy.*Gy);

imshow(Eext,[min(min(Eext)),max(max(Eext))]);
pause();


sizeFFT = size(Eext)+size(Fx)-1;

fftN = fft2(Eext,sizeFFT(1),sizeFFT(2));
fftFX = fft2(Fx,sizeFFT(1),sizeFFT(2));
fftFY = fft2(Fy,sizeFFT(1),sizeFFT(2));

vectorFieldX = ifft2(fftN.*fftFX);
vectorFieldY = ifft2(fftN.*fftFY);

rmv = (size(Fx) - 1)/2;

vectorFieldX = vectorFieldX(rmv(1)+1:end-rmv(1), rmv(2)+1:end-rmv(2), :);
vectorFieldY = vectorFieldY(rmv(1)+1:end-rmv(1), rmv(2)+1:end-rmv(2), :);

s2 = size(Eext);

Fext = zeros(s2(1),s2(2),2);

Fext(:,:,1) = vectorFieldX;
Fext(:,:,2) = vectorFieldY;

Fsq = Fext.*Fext;
Fmag = sqrt(Fsq(:,:,1)+Fsq(:,:,2)) + eps;
Fext(:,:,1) = Fext(:,:,1)./Fmag;
Fext(:,:,2) = Fext(:,:,2)./Fmag;

end