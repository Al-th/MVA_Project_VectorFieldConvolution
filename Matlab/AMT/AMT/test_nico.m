clear;
clc;

%%
% Parameters configuration

gamma = 1.7;
tau = 0.5;
RES = 0.5;
GVF_ITER = 1000;
mu = 0.2;
R = 100;

%%
% Init synthetic image 
n = 128;
m = 256;
f = zeros(n,m);
f((n/2-2):(n/2+2),28:32) = 255;
f(:,126:130) = 255;
f(:,208:212) = 64;
figure(1);
imshow((255*ones(n,m)-f),[0,255]);

%%
%Compute Fext

%VFC field
%K = AM_VFK(2, 128, 'power',gamma);
%Fext = AM_VFC(f,K);

%GVF filed
%Fext = AM_GVF(f, mu, GVF_ITER, 1);


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
[x y] = meshgrid(1:4:(m-1),1:4:(n-1));
vt = [x(:) y(:)];   % seeds
VT = zeros([size(vt) 420]);
VT(:,:,1) = vt;
for i=1:419, % moving these seeds
    vt = AC_deform(vt,0,0,tau,Fext,1);
    VT(:,:,i+1) = vt;
end

%Define ground truth to color streamline according to FOI
impulse_noise = zeros(n,m);
impulse_noise((n/2-2):(n/2+2),28:32) = 255;
[iTy, iTx] = find(impulse_noise);
weak_edge = zeros(n,m);
weak_edge(:,208:212) = 128;
[wTy, wTx] = find(weak_edge);

figure(1);
hold on
for i=1:size(vt,1),
   if min(abs(VT(i,1,end)-iTx)+abs(VT(i,2,end)-iTy))<=2,
       plot(squeeze(VT(i,1,:)), squeeze(VT(i,2,:)),'r','linewidth',1)
   elseif min(abs(VT(i,1,end)-wTx)+abs(VT(i,2,end)-wTy))<=2,
       plot(squeeze(VT(i,1,:)), squeeze(VT(i,2,:)),'y','linewidth',1)
   else
       plot(squeeze(VT(i,1,:)), squeeze(VT(i,2,:)),'b','linewidth',1)
   end
end
hold off