clc;
clear
close all;

% read Image
maindir = cd;
datadir = 'directoryofdata';
cd(datadir);
framer = imread('acquiredimage.tif');

%% remove undesired background for display image
cd(maindir)
ang = 90;
fixr = imrotate(framer,ang,'crop');
make_mask_fcn_v2(fixr); 
make_mask_fcn_v3(fixr); 

%% bck and signal 
masb = mask2.*(~mask); 
imgdis = fixr.*uint16(mask);
imgbck = fixr.*uint16(masb);
subplot(1,2,1); imagesc(imgdis); colormap('turbo'); colorbar; caxis([0 40834]);
subplot(1,2,2); imagesc(imgbck); colormap('turbo'); colorbar; caxis([0 40834]);

%% calculate snr
snrval = snr(double(imgdis),double(imgbck));
save('bordermasks.mat','masb','mask','snrval');