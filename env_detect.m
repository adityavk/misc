close all;
clear all;

%given constants
fc=40e3;                                            %carrier frequency
fm=2e3;                                             %message frequency
ka=0.5;                                             %sensitivity factor

tc=1/fc;
tm=1/fm;
ts=tc/300;
n=1e4;                                              %no. of samples

t=[0:ts:ts*n];                                      %sampling time instants
size_t=size(t,2);
tau=[tc:1e-6:tm];                                   %varying time constant
size_tau=size(tau,2);

m_t=cos(2*pi*fm*t);                                 %m(t)=message signal
c_t=cos(2*pi*fc*t);                                 %c(t)=carrier signal
shift_m_t= 1+(ka.*m_t);                             %shifted m(t) after making it >0
mod_t= shift_m_t .*c_t;                             %modulated signal

Vo=zeros(size_tau,size_t);            
%Voltage output Vo(t) in one row for one value of tau 
%and different rows of Vo(t) for different tau

for i=1:size_tau
    for j=1:size_t
        if j==1
            Vo(i,j)= 1+ka;                          %Vo(0)=(1+ka) for all tau
        elseif mod_t(j-1) < Vo(i,j-1)
            Vo(i,j)=Vo(i,j-1)*exp(-ts/tau(i));      %capactior discharging
        else
            Vo(i,j)=mod_t(j-1);                     %else Vo same as AM
        end
    end
end

%calculate MSE
for i=1:size_tau
    mse(i)= sum((shift_m_t-Vo(i,:)).^2);            %calculate total MSE
    mse(i)=(tc/(n*ts))*mse(i);                      %MSE per cycle
end

% %plot mse vs tau
% plot(tau.*1e6,mse);
% xlabel('\tau  (in \mus)');ylabel('MSE per cycle');
% title('MSE vs \tau');

[mse_min,tau_min]=min(mse);                         %calculate tau for minimum MSE
fprintf('Tau for minimum MSE = %0.2f X 10^-6 s\n',tau(tau_min)*1e6);

%plot am and output for tau_min
figure(2)
plot(t*1e3,mod_t);
axis([0 1 -1.6 1.6]);
xlabel('t (in ms)');
hold on
plot(t*1e3,Vo(tau_min,:));
title(strcat('AM and output signal at \tau_{min} = ',num2str(tau(tau_min)*1e6),' \mus'));
legend('mod(t)=(1+k_{a}m(t))cos(2\pif_{c}t)','V_{o}(t)');