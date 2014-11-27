function plot_streamline(it,step,Fext,edge_map,ground_truth_map)

[n,m] = size(edge_map);
[x y] = meshgrid(1:step:m,1:step:n);
vt = [x(:) y(:)];   % seeds
VT = zeros([size(vt) it]);
VT(:,:,1) = vt;
for i=1:(it-1), % moving these seeds
    vt = AC_deform(vt,0,0,0.5,Fext,1);
    VT(:,:,i+1) = vt;
end

%Define ground truth to color streamlines according to FOI
[Ty, Tx] = find(ground_truth_map);

imshow(edge_map,[min(min(edge_map)),max(max(edge_map))]);
hold on
for i=1:size(vt,1),
   if min(abs(VT(i,1,end)-Tx)+abs(VT(i,2,end)-Ty))<=2,
       plot(squeeze(VT(i,1,:)), squeeze(VT(i,2,:)),'r','linewidth',1)
   else
       plot(squeeze(VT(i,1,:)), squeeze(VT(i,2,:)),'b','linewidth',1)
   end
end
hold off