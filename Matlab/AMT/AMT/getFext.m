function [Fext, noisyU] = getFext(Fx,Fy, imName,downscaleFactor);
noisyU = imread(imName);
noisyU = downsample2D(noisyU,downscaleFactor);
f = double(noisyU);



sizeFFT = size(f)+size(Fx)-1;

fftN = fft2(f,sizeFFT(1),sizeFFT(2));
fftFX = fft2(Fx,sizeFFT(1),sizeFFT(2));
fftFY = fft2(Fy,sizeFFT(1),sizeFFT(2));

vectorFieldX = ifft2(fftN.*fftFX);
vectorFieldY = ifft2(fftN.*fftFY);

rmv = (size(Fx) - 1)/2;

vectorFieldX = vectorFieldX(rmv(1)+1:end-rmv(1), rmv(2)+1:end-rmv(2), :);
vectorFieldY = vectorFieldY(rmv(1)+1:end-rmv(1), rmv(2)+1:end-rmv(2), :);

s2 = size(f);

Fext = zeros(s2(1),s2(2),2);
Fext(:,:,1) = vectorFieldX;
Fext(:,:,2) = vectorFieldY;


[Gx,Gy] = gradient(f);



I = sqrt(Gx.*Gx+Gy.*Gy);
I = im2bw(I,graythresh(I));

for i = 1:s2(1)
    for j = 1:s2(2)
        if(I(i,j) )
            Fext(i,j,1) = Gx(i,j);
            Fext(i,j,2) = Gy(i,j);
        end
    end
end

Fmag = sqrt(sum(Fext.*Fext,3))+eps;
Fext(:,:,1) = Fext(:,:,1)./Fmag;
Fext(:,:,2) = Fext(:,:,2)./Fmag;


figure()
[x_im,y_im] = meshgrid(1:1:s2(2),1:1:s2(1));
quiver(x_im,y_im,Fext(:,:,1),Fext(:,:,2));

end