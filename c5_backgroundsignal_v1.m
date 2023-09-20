clc;
clear
close all;

% read Image
maindir = cd;
datadir = 'directoryofdata';
cd(datadir);
framer = imread('acquiredimage_ambienton.tiff');
framev = imread('ambientoff.tiff');

%% calculate residual 
cd(maindir)
maeq = framer-framev;
figure; imagesc(maeq);

%% plot mean intensity for regions of interest
figure; imagesc(framer);
figure; imagesc(framev);
figure; plot(maeq(:),'LineWidth',2); hold on
legend('Fluobeam')
ylabel(strcat('Residual'));
xlabel(strcat('Pixels'));
set(gca,'FontWeight','bold','FontSize',18);
title('Background');
saveas(gcf,'background.png');
save('background','maeq');
