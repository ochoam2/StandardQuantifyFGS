
clc;
clear
close all;

% read Image
maindir = cd;
datadir = 'directoryofdata';
cd(datadir);
framer = imread('acquiredimage.tif');
framer = double(sum(framer,3));
cropped = framer;
% cropped = framer([1:161,194:592,622:768],[1:225,305:680,780:1024]);

%% select region
line = size(cropped,1)/2;
linereg = mean(cropped(line-50:1:line+50,:));
linereg = linereg./max(linereg);

%% plot mean intensity for regions of interest
figure;
imagesc(cropped); colormap hot; colorbar; caxis([0 10000]);

figure;
plot(linereg,'-.','LineWidth',2); hold on; 
ylabel(strcat('Norm intensity'));
xlabel(strcat('Pixels'));
set(gca,'FontWeight','bold','FontSize',18);
title('FOV Uniformity');
saveas(gcf,'FOVuniformity.png');
save('FOVuniformity','linereg');