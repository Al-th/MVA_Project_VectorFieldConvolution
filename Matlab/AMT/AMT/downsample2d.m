function [ P ] = downsample2d(M,ratio)
x = ratio;
y = ratio;

N = downsample(M,x);
N = N';
P = downsample(N,y);
P = P';
Y = P';
end