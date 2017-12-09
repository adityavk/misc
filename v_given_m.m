function y=v_given_m(m,X,A)
% returns v() when m() is given using conditional mean concept

n=length(m);                                                                %size of m()
y=zeros(n-1,1);                                                             %size of v() to be returned
f=zeros(n,1);                                                               %stores the indices of elements in range m(k)<m<m(k+1)
for i=1:(n-1)
  f=find(X>=m(i) & X<m(i+1));
  N=length(f);                                                              %no. of elements in that range
  sigma=sum(X(f));                                                          %sum of elements in that range
  if N~=0
      y(i)=sigma/N;
  elseif m(i)>=0                                                            %consider m(i) closer to 0 if no elements are present
      y(i)=m(i);
  else y(i)=m(i+1);
  end
end
end