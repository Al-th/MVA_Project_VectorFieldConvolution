clear;
clc;

alpha = .5;
beta = 0.1;
tau = 0.5;
RES = 0.5;
R = 100;


n = 256;
m = 256;
f = zeros(n,m);
f((n/2-2):(n/2+2),28:32) = 255;
f(:,126:130) = 255;
f(:,208:212) = 128;
figure(1);
imshow((255*ones(n,m)-f),[0,255]);

%%
%Compute Fext
K = AM_VFK(2, 128, 'power',1.8);
FFTsize = size(f) + size(K(:,:,1)) - 1;
k = K(:,:,1) + j*K(:,:,2);      % consider the vectors as complex numbers
temp = ifft2(fft2(f, FFTsize(1), FFTsize(2)) .* fft2(k, FFTsize(1), FFTsize(2)));

% remove padded points
rmv = (size(K(:,:,1)) - 1)/2;
temp = temp(rmv(1)+1:end-rmv(1), rmv(2)+1:end-rmv(2), :);
Fext(:,:,2) = imag(temp);
Fext(:,:,1) = real(temp);

% Normalize
Fmag = sqrt(sum(Fext.*Fext,3))+eps;
Fext(:,:,1) = Fext(:,:,1)./Fmag;
Fext(:,:,2) = Fext(:,:,2)./Fmag;

R = 28;

%%
%Show Fext vector field
figure(2);
AC_quiver(Fext,(255*ones(n,m)-f));

%%
%Show streamline
[x y] = meshgrid(1:2:(n-1),1:2:(m-1));
vt = [x(:) y(:)];   % seeds
VT = zeros([size(vt) 40]);
VT(:,:,1) = vt;
for i=1:39, % moving these seeds
    vt = AC_deform(vt,0,0,tau,Fext,1);
    VT(:,:,i+1) = vt;
end

% for i=1:100, % moving these seeds
%     vt  = AC_deform(vt,alpha,beta,tau,Fext,5);
%     vt = AC_remesh(vt,1);
%     
%     AC_quiver(Fext,f);
%     hold on;
%     plot(VT(i,:,1),VT(i,:,2),'.r');
%     hold off
%     pause(0.1);
% end
figure(1);
hold on
for i=1:size(vt,1),
   plot(squeeze(VT(i,1,:)), squeeze(VT(i,2,:)),'r','linewidth',1)            
end
hold off
%axis equal; axis 'ij';
%axis([1 (m-1) 1 (n-1)])