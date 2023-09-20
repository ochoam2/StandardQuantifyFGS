
clc
clear
close all hidden

% read xls's
num = xlsread('spectrometer.txt',1);
num = double(table2array(FLMT0996211121847996));

% plot 
figure;
plot(num(:,1), num(:,2),'-','LineWidth',2); hold on
fwhmN = fwhm(num(:,1), num(:,2));

ylabel(strcat('Counts'));
xlabel(strcat('Wavelength'));
text(700,40000,strcat('FWHM =' ,num2str(fwhmN)));
set(gca,'FontWeight','bold','FontSize',18);
title('Excitation Wavelength Emission');
xlim([600 900]);

wldata = [num(:,1), num(:,2)];
save('excitationband','wldata','fwhmN');

