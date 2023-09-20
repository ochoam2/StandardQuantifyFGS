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
ang = 182;
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
conc = [{'QD'} {'0'}   {'1'}   {'3'}   {'10'}  {'30'}  {'100'}  {'300'}  {'1000'}]; 
for k = 1:9
    mask = double(eval(['c' num2str(k)])); %run in breakpoints
    mask(mask == 0) = NaN;
    thimg = mask.*fixr;
    thimg(thimg<0.*max(thimg(:))) = NaN;
    maskall(:,:,k) = thimg; 
    masklin(:,k) = thimg(:);
    figure(1); imagesc(squeeze(maskall(:,:,k)));
    pause(0.1);
end

%% plot mean intensity for regions of interest
figure;
boxplot(masklin); 
% bxplotcolor(gca);Fig 10
legend('VisionSense')
ylabel(strcat('Intensity (a.u)'));
xlabel(strcat('Concentration (nM)'));
xticklabels(conc)
set(gca,'FontWeight','bold','FontSize',18);
title('Concentration Change');

linemns = (nanmean(masklin./max(masklin(:))))';  
linestds = (nanstd(masklin./max(masklin(:))))';
save('sensitivityline','masklin',"linemns","linestds");
saveas(gcf,'sensitivityline.png');
