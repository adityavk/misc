function y=m_given_v(v,A)
%returns m() given v() and range [A,-A]
n=size(v,1);
y=zeros(n+1,1);
y(1)=-A;
y(end)=A;
for i=1:(n-1)
  y(i+1)=0.5*(v(i)+v(i+1));
end
end