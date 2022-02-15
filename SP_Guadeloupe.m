%% accelerations are integrated twice to produce displacements
clear all;
close all;

%% Design High Pass Filter

fs = 1025.64; % Sampling Rate

fc = 1/600; % Cut off Frequency

order = 6; % 6th Order Filter

ti=[0:0.000975:15.8808]; %The time of the acceleration time series (here 40 seconds with a sampling time of 1/200)
time=ti';

%% Filter Acceleration Signals using a Butterworth Filter

[b1 a1] = butter(order,fc,'high');

%path=strcat('C:\Users\syadav\Documents\PhD\Experiments\Signal processing',file); %the path of the acceleration file
fileName = 'Guadeloupe_modified_Cauchylaw' %Put the first file name here (make sure to replace , from all the values in excel)
acc_main=xlsread(fileName); 
acc=1*acc_main(:,2);        % Change the numerical value as per required for instance 2 for signal 200%, 3 for signal 300%
%maximum(i)=max(acc);
accf=filtfilt(b1,a1,acc);

PGA=max(abs(accf));
L=length(acc_main);
%% First Integration (Acceleration - Velocity)
i=1:1:L;
velocity(i,1)=cumtrapz(time,accf);
PGV=max(abs(velocity));

%% Second Integration (Velocity - Displacement)
velf=filtfilt(b1,a1,velocity);
i=1:1:L; % change as per the number of row of data
displacement(i,1)=cumtrapz(time,velf);
PGD=max(abs(displacement));

%% plot 
figure (1)
subplot(3,1,1), plot(time,accf),ylabel('Acceleration [m/s^2]'),ylim([-15,15])
subplot(3,1,2), plot(time,velocity), ylabel('Velocity [m/s]')
subplot(3,1,3), plot(time,displacement), xlabel('Time [s]'),ylabel('Displacement [m]'),ylim([-0.015,0.015])
%print(gcf,'-dtiff', '-r600', 'Guadeloupe_300 amplitude')

%% Power spectrum
% figure (2)
% spectrogram(accf)


