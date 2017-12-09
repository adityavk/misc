% close all;
% clear all;

%load('Dat_2.mat');
n=size(X,2);
dx=0.05;
A=5;
m=2*A/dx;
f=zeros(m,1);
t=zeros(m,1);
for i=1:m
    f(i)=length((find(X>=(-A+i*dx) & X<(-A+(i+1)*dx))));
    t(i)=-A+(i+0.5)*dx;
end
plot(t,f);
normfit(f)