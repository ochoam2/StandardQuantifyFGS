
clc;
clear
close all;

% read Image
maindir = cd;
datadir = 'directoryofdata';
cd(datadir);
b1 = imread('acquiredimage.tif');

%% remove background ====================================
% (The background pixels are thresholded through removing pixels that are 10% less than the maximum value and then images are displayed)
cd(maindir)
n= 9; 
ang = 0;
for k = n
img = sum(b1,3);
norm = imrotate(img,ang,'crop');
% norm = norm./max(norm(:));
norm(norm<0.2*max(max(norm))) = 0;
figure(1); imagesc(norm); colormap hot;  colorbar; axis off;
end

%% make masks =========================================
% For this analysis we are using only the 1.12 lp/mm pair and it can not be guaranteed this pair will always be at the same location, 
% hence why I thought manual selection will be more accurate. When running this section it will open 18 images. You can also Zoom on the figure, etc. Per each image one box 
% should be drawn for the horizontal bars and another box for vertical bars at the 1.12 lp/mm pair. For drawing the box right click "options" on the figure GUI and in "Brush Opts" click "Square". 
%Then take the cursor on top of the blue space and then move the mouse scroler up and down to increase the box size. Pressing shift on the keyboard at the same
% time will allow to rotate the box. Once the box is the same size and position as horizontal or vertical regions of the 1.12lp/mm pair, just position it and click on top of each region respectively. 
% Again 1 region of interest is needed for horizontal and 1 for vertical. So it will be 2 squares besides each other. Once masks have been placed then click "Save to Workspace as "mask"" button. 
% Then run the upcoming section. For this section if you are saving the masks for Figure 18 then k=18 and so on. You might now close the figure for which the mask has been saved and proceed 
% to the next one until completing all 18. 

for k = 1:n %run 1 to end 
    make_mask_fcn_v2(norm); 
end

%% run after selecting each region from previous section
k = 1;
maskall{k} = mask;
clear mask

 %% split hor and ver =======================================
 % I wanted to look also at the difference between horizontal and vertical frequencies, hence why I am selecting these regions separately to plot them separately. 
 % Run this section, then click on top of Left box then press Enter then click on top of Right box and click Enter. Keep repeating this until k = 18 on the command window.
 for k =1:n
 hor{k} = double(bwselect(maskall{k}));
 ver{k} = double(bwselect(maskall{k}));
 k
 end
 if k ==n
     close all;
 end

%% testing ctf numbers as metric
% calculates CTFs for both horizontal and vertical frequencies. You can also load mask values I have already saved. They are in variable "hovermask" so please load this one 
% if you want to skip the 3 previous sections.
save('resmask2nd','hor','ver')
ctfsjoin = {[]};
for k = 1:n
    m1 = double(hor{k});
    m1(m1==0) = NaN;
    m2 = double(ver{k});
    m2(m2==0) = NaN;
    img = norm;    

    imghor = m1.*img;
    horval = isnan(imghor); 
    ih = find(~horval); 
    horval = imghor(ih);
    T1 = length(horval)/5;
    horvalmin = sort(horval,'ascend');
    horvalmax = sort(horval,'descend');

    imgver = m2.*img;
    verval = isnan(imgver); 
    iv = find(~verval); 
    verval = imgver(iv);
    T2 = length(horval)/5;    
    vervalmin = sort(verval,'ascend');
    vervalmax = sort(verval,'descend');
    
    ctfhor = (mean(horvalmax(1:T1)) - mean(horvalmin(1:T1)))./(mean(horvalmax(1:T1)) + mean(horvalmin(1:T1))).*100;
    ctfver = (mean(vervalmax(1:T2)) - mean(vervalmin(1:T2)))./(mean(vervalmax(1:T2)) + mean(vervalmin(1:T2))).*100;
    ctfsjoin{k} = [ctfhor;ctfver];
end
ctfsjoin = cell2mat(ctfsjoin);

%% plot mean intensity for regions of interest
cd(maindir);
figure(3);
plot(ctfsjoin','-o','LineWidth',2);
ylabel(strcat('Zero Pixel Counts (a.u)'));
xlabel(strcat('Depth of Field (cm)'));
set(gca,'FontWeight','bold','FontSize',18);
title('Depth of Field');

hold on;
ctfsjoinmean = mean(ctfsjoin,1);
plot(ctfsjoinmean,'LineWidth',3)
saveas(gcf,'depthoffield.png');
save('resolution2nd','ctfsjoin','ctfsjoinmean');
legend('horizontal','vertical','average');