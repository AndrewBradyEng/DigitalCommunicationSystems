%% Define Parameters

data = randi([0, 1], 1, 10);    % Binary Information
B_p = 0.000001;    % bit period

%% Represent binary info as digital signal

binary_data=[]; 
for n=1:1:length(data)
    if data(n)==1;
       se=ones(1,100);
    else data(n)==0;
        se=zeros(1,100);
    end
     binary_data=[binary_data se];
end

%Create the time vector for the signal
t1=B_p/100:B_p/100:100*length(data)*(B_p/100);

%% PSK Modulation

A=5;    % Amplitude of carrier signal 
R_b=1/B_p;    % bit rate
F_c=R_b*2; % carrier frequency 
t2=B_p/99:B_p/99:B_p; % time vector
ss=length(t2);

modulated_data=[];
for (i=1:1:length(data))
    if (data(i)==1)
        y=A*cos(2*pi*F_c*t2);
    else
        y=A*cos(2*pi*F_c*t2+pi);   %A*cos(2*pi*f*t+pi) means -A*cos(2*pi*f*t)
    end
    modulated_data=[modulated_data y];
end

%Create the time vector for the signal
t3=B_p/99:B_p/99:B_p*length(data);

%% Perform demodulation

demodulated_data=[];
for n=ss:ss:length(modulated_data)
  t=B_p/99:B_p/99:B_p;
  y=cos(2*pi*F_c*t); 
  mm=y.*modulated_data((n-(ss-1)):n);
  t4=B_p/99:B_p/99:B_p;
  z=trapz(t4,mm);   % intregation 
  zz=round((2*z/B_p));                                     
  if(zz>0)  % logic level = (A+A)/2=0 
    a=1;    % A*cos(2*pi*f*t+pi) means -A*cos(2*pi*f*t)
  else
    a=0;
  end
  demodulated_data=[demodulated_data a];
end

%% Represent binary info as digital signal after demodulation

binary_data=[];
for n=1:length(demodulated_data);
    if demodulated_data(n)==1;
       se=ones(1,100);
    else demodulated_data(n)==0;
        se=zeros(1,100);
    end
     binary_data=[binary_data se];
end

%Create the time vector for signal
t4=B_p/100:B_p/100:100*length(demodulated_data)*(B_p/100);

%% Plots

figure();
%Original binary signal
subplot(3,1,1);
plot(t1,binary_data,'Color','r');
grid on;
axis([ 0 B_p*length(data) -.5 1.5]);
ylabel('Amplitude(V)');
xlabel('Time(s)');
title('Binary Signal');

%PSK modulated signal
subplot(3,1,2);
plot(t3,modulated_data,'Color','g');
xlabel('Time(s)');
ylabel('Amplitude(V)');
title('PSK Modulated Signal');

%Demodulated signal
subplot(3,1,3)
plot(t4,binary_data);
grid on;
axis([ 0 B_p*length(demodulated_data) -.5 1.5]);
ylabel('Amplitude(V)');
xlabel('Time(s)');
title('Demodulated PSK Signal');
