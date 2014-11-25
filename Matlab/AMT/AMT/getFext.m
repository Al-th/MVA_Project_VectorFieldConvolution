function [Fext] = getFext(Fx,Fy, EdgeMap);



sizeFFT = size(EdgeMap)+size(Fx)-1;

fftN = fft2(EdgeMap,sizeFFT(1),sizeFFT(2));
fftFX = fft2(Fx,sizeFFT(1),sizeFFT(2));
fftFY = fft2(Fy,sizeFFT(1),sizeFFT(2));

vectorFieldX = ifft2(fftN.*fftFX);
vectorFieldY = ifft2(fftN.*fftFY);

rmv = (size(Fx) - 1)/2;

vectorFieldX = vectorFieldX(rmv(1)+1:end-rmv(1), rmv(2)+1:end-rmv(2), :);
vectorFieldY = vectorFieldY(rmv(1)+1:end-rmv(1), rmv(2)+1:end-rmv(2), :);

s2 = size(EdgeMap);

Fext = zeros(s2(1),s2(2),2);

Fext(:,:,1) = vectorFieldX;
Fext(:,:,2) = vectorFieldY;

Fsq = Fext.*Fext;
Fmag = sqrt(Fsq(:,:,1)+Fsq(:,:,2)) + eps;
Fext(:,:,1) = Fext(:,:,1)./Fmag;
Fext(:,:,2) = Fext(:,:,2)./Fmag;

end