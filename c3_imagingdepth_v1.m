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
ang = 88;
fixr = imrotate(framer,ang,'crop');
make_mask_fcn_v2(fixr); 

%% displayed image
imgdis = fixr.*uint16(mask);
figure; imagesc(imgdis); colormap turbo; set(gca,'FontSize',22,'FontWeight','bold'); colorbar; axis off;

%% select regions for individual wells for quantification
make_mask_fcn_v2(fixr); 

%% apply well regions and select for quantification order
fixr = double(fixr.*uint16(mask));

c1 = bwselect(imbinarize(fixr));
c2 = bwselect(imbinarize(fixr));
c3 = bwselect(imbinarize(fixr));
c4 = bwselect(imbinarize(fixr));
c5 = bwselect(imbinarize(fixr));
c6 = bwselect(imbinarize(fixr));
c7 = bwselect(imbinarize(fixr));
c8 = bwselect(imbinarize(fixr));
c9 = bwselect(imbinarize(fixr));

%% plot mean intensity and std per region
means = zeros(1,9);
stds = zeros(1,9);
conc = [{'0.5'} {'1.0'}   {'1.5'}   {'2.0'}   {'3.0'}  {'4.0'}  {'5.0'}  {'6.0'}  {'control'}]; 
for k = 1:9
    mask = double(eval(['c' num2str(k)])); %run in breakpoints
    mask(mask == 0) = NaN;
    thimg = mask.*fixr;
    thimg(thimg<0.5.*max(thimg(:))) = NaN;
    maskall(:,:,k) = thimg; 
    masklin(:,k) = thimg(:);
    figure(1); imagesc(squeeze(maskall(:,:,k)));
    pause(0.1);
end

%% plot mean intensity for regions of interest
figure;
boxplot(masklin); 
% bxplotcolor(gca);
legend('Fluobeam Preclinical')
ylabel(strcat('Intensity (a.u)'));
xlabel(strcat('Depth (mm)'));
xticklabels(conc)
set(gca,'FontWeight','bold','FontSize',18);
title('Imaging Depth');

linemns = (nanmean(masklin./max(masklin(:))))';  
linestds = (nanstd(masklin./max(masklin(:))))';
save('imagingdepth','masklin','linemns','linestds');
saveas(gcf,'imagingdepth.png');

