close all;
clear all;

load('replace your signal file name here')              %load given file

%given constants
fm=200;
fc=4e3;
N=100;
fs=N*fc;
n=size(modmt,2);                            %size of input

t_i=[0:(1/fs):((n-1)/fs)];                  %sampling times

x_i=zeros(1,n);                             %output of multiplier in i-chanel
x_q=zeros(1,n);                             %output of multiplier in q-chanel
phase=zeros(1,n+1);                         %phase of VCO at time t
lpf_i=zeros(1,n);                           %lpf output of i-channel
lpf_q=zeros(1,n);                           %lpf output of q-channel
sum_i=0;                                    %variable to maintain sum of x_i from time (t-N+1) to t
sum_q=0;                                    %similarly for sum of x_q

for t=1:n
    %--------------product modulator------------------%
    x_i(t)=modmt(t)*cos(2*pi*fc*t_i(t)+phase(t));
    x_q(t)=modmt(t)*sin(2*pi*fc*t_i(t)+phase(t));
    
    %---------low pass filter as integrator-----------%
    %add the present value of x(t) and if t>N, subtract x(t-N)
    
    sum_i=sum_i+x_i(t);
    sum_q=sum_q+x_q(t);
    if t>N
        sum_i=sum_i-x_i(t-N);
        sum_q=sum_q-x_q(t-N);
    end
    lpf_i(t)=sum_i;
    lpf_q(t)=sum_q;
    
    %----------------VCO phase update-----------------%
    phase(t+1)=phase(t)-(0.01*pi*sign(lpf_i(t)*lpf_q(t)));
    
end

%Phase offset of given DSB signal
fprintf('Phase offset of given DSB-SC signal is %f radians(%f%c)\n'...
    ,phase(n+1),(mod(phase(n+1),(2*pi))*180/pi),char(176));

%plot phase-vs-time
plot(t_i,phase(1:n));
title('Phase vs time');
xlabel('Time(s)');
ylabel('\psi(t) (rad)');

figure

%plot lowpass filter output of channel-i
plot(t_i,lpf_i);
title('Output of Channel-i output');
xlabel('Time(s)');
ylabel('lpf_i(t)');
