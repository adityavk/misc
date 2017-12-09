close all;
clear all;

%for loading and plotting for both data files, fil variable is used
for fil=1:2
    load(strcat('Dat_',num2str(fil),'.mat'));                               %load 1st/2nd file
    
    N=length(X);                                                            %length of input X
    A=10;                                                                   %given dynamic range
    Q=6;                                                                    %Quantizer resolution
    max_iter=20;                                                            %maximum iterations

    mse=zeros(max_iter,Q);                                                  %columnwise MSE for each resolution

    k=1;
    while k<=Q
        L=2^k;                                                              %no. of levels
        m=linspace(-A,A,L+1)';                                              %stores m(k)
        v=zeros(L,1);                                                       %stores v(k)
        ctr=0;                                                              %counter
        while ctr<max_iter
            ctr=ctr+1;
            v=v_given_m(m,X,A);                                             %defined later
            m=m_given_v(v,A);                                               %defined later
            for i=1:length(X)                                               %sum of |m-v|^2
                mse(ctr,k)=mse(ctr,k)+(min(abs(X(i)-v)))^2;
            end
        end
        k=k+1;
    end
    mse=mse./N;
    
    %plot mse vs max_iter for each Q
    figure
    for i=1:Q
        plot(1:max_iter,mse(:,i),'-x');
        hold on
    end
    xlabel('No. of Iterations');
    ylabel('MSE');
    title(['MSE vs Max. Iterations for Data-',num2str(fil)]);
    
    %plot converged mse vs Q
    figure
    plot([1:6],mse(end,:),'-o','MarkerSize',6,'MarkerFaceColor','black');
    xlabel('Quantizer Resolution');
    ylabel('Converged MSE');
    title(['Converged MSE vs Quantizer Resolution for Data-',num2str(fil)]);
    
end

%----------------------------------------------------------------------------------------------------------------------%

% function y=v_given_m(m,X,A)
% % returns v() when m() is given using conditional mean concept
% 
% n=length(m);                                                                %size of m()
% y=zeros(n-1,1);                                                             %size of v() to be returned
% f=zeros(n,1);                                                               %stores the indices of elements in range m(k)<m<m(k+1)
% for i=1:(n-1)
%   f=find(X>=m(i) & X<m(i+1));
%   N=length(f);                                                              %no. of elements in that range
%   sigma=sum(X(f));                                                          %sum of elements in that range
%   if N~=0
%       y(i)=sigma/N;
%   elseif m(i)>=0                                                            %consider m(i) closer to 0 if no elements are present
%       y(i)=m(i);
%   else y(i)=m(i+1);
%   end
% end
% end

%----------------------------------------------------------------------------------------------------------------------%

% function y=m_given_v(v,A)
% %returns m() given v() and range [A,-A]
% n=size(v,1);
% y=zeros(n+1,1);
% y(1)=-A;
% y(end)=A;
% for i=1:(n-1)
%   y(i+1)=0.5*(v(i)+v(i+1));
% end
% end