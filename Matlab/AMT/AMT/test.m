clear;
clc;

[Fx,Fy] = getKernel(32,1);

alpha = .5;
beta = 0.0;
tau = 0.5;
RES = 0.5;
R =20
vt = AC_initial(RES, 'circle', [32 32 R]);   % seeds

for i = [1]
    [Fext,resizedIm] = getFext(Fx,Fy,'im_Unoisy.bmp',i);
    s = size(Fext);
    [x_im,y_im] = meshgrid(1:s(2),1:s(1));

    for i=1:100, % moving these seeds
        vt = AC_deform(vt,alpha,beta,tau,Fext,5);
        vt = AC_remesh(vt,1);
        imshow(resizedIm);
        hold on;
        plot(vt(:,1),vt(:,2),'*r');
        quiver(x_im,y_im,Fext(:,:,1),Fext(:,:,2));
        hold off
        pause(0.1);
    end
    pause();
    vt = vt.*2;
end


