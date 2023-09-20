
clc;
clear

clc;
clear
close all;

% read Image
maindir = cd;
datadir = 'directoryofdata';
cd(datadir);
framer = double(imread('acquiredimage.tif'));

%% select regions of interest per concentration
cd(maindir)
fixr = framer;
fixr(fixr<0.1*(max(max(fixr)))) = 0;
c1 = bwselect(imbinarize(fixr));
c2 = bwselect(imbinarize(fixr));

%% calculate image distance between regions based on distribution
for k = 1:2
    p(:,:,k) = eval(['c' num2str(k)]).*fixr;
end
p1region = squeeze(p(:,:,1));
p1region = nanmean(p1region);
lmx1 = double(islocalmax(p1region,'MinSeparation',10)); 
subplot(2,1,1); plot(p1region); hold on; plot(lmx1); title('Point distribution 1');

p2region = squeeze(p(:,:,2));
p2region = nanmean(p2region);
lmx2 = double(islocalmax(p2region,'MinSeparation',10));
subplot(2,1,2); plot(p2region); hold on; plot(lmx2); title('Point distribution 2');

[pks1,locs1] = findpeaks(lmx1);
[pks2,locs2] = findpeaks(lmx2);

for k = 1:24
    distance1(k) = locs1(k+1) - locs1(k);
    distance2(k) = locs2(k+1) - locs2(k);
end

%% plot mean intensity for regions of interest
figure;
dista = [distance1./max(distance1); distance2./max(distance2)];
distamean = mean(dista);
distastd = std(dista);
boxplot(dista); 
% bxplotcolor(gca);
ylim([0 1]);
legend('VisionSense')
ylabel(strcat('In Between Point Distance (a.u)'));
xlabel(strcat('Horizontal Point Number (a.u)'));
set(gca,'FontWeight','bold','FontSize',18);
title('Distortion');
saveas(gcf,'distortion.png');
save('distortion','dista','distamean','distastd');