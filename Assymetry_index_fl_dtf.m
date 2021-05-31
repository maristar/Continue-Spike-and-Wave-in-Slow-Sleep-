function [DTF]=assymetry_index_fl_dtf(result1, timeVec2, B, xyz, textmeasure, num_epochs, nchan,s, name, now)
% 3-6-2011
%% 

textmeasure='DTF'; %input('measure:__','s');
% result1=resultscor.DTFtheta.gamma_Freq; %%usually it is resultscor.correlation partcor
% s=resultscor.s;
% timeVec2=resultscor.timeVec2; %% usually it is timeVec2, in KLe it is timevec2
% nchan=resultscor.nchan;


%% 
%  AVERAGE DURING AWAKE 

average=squeeze(mean(result1(:,:,:),1));
% plot 
figure;imagesc(average);title([textmeasure ': average connectivity ']);
set(gca,'Ytick', 1:nchan); set(gca, 'XTick', 1:nchan); 
set(gca, 'YTickLabel', s); set(gca, 'XTickLabel', s);
axis xy; axis tight; colorbar('location','EastOutside')
figure_temp=[textmeasure '-average connectivity-' name];saveas(gcf, figure_temp, 'fig')
clear figure_temp 
DTF.DTFaverage=average;

figure; plot2deeg3(average, xyz, B); title([name '-' textmeasure ': average connectivity ']);
figure_temp=['Lines-' textmeasure '-average connectivity ' name];saveas(gcf, figure_temp, 'fig')
clear figure_temp 
 
%% 
% AVERAGE DURING AWAKE ABOVE THRESHOLD 0.5 

average_pos=zeros(nchan, nchan);
threshold=max(max(tril(average, -1)))/2;
for hh=1:nchan
    for kk=1:nchan
        if average(kk,hh)>threshold; %% this threshold could change depending on average resutls
            average_pos(kk,hh)=average(kk,hh);
        else
            average_pos(kk,hh)=0;
        end
    end
end

clear hh kk 

% Plot
figure; imagesc(average_pos);
title([textmeasure ': ''average connectivity above threshold ' num2str(threshold)]);
set(gca,'Ytick', 1:nchan); set(gca, 'XTick', 1:nchan); 
set(gca, 'YTickLabel', s); set(gca, 'XTickLabel', s);
axis xy; axis tight; colorbar('location','EastOutside');
figure_temp=[textmeasure '- average conn thr ' name];
saveas(gcf, figure_temp, 'fig')
clear figure_temp 

DTF.averagepos=average_pos;
DTF.awakethr=threshold;

% Plot Lines
figure; plot2deeg3_fl(average_pos, xyz, B); title([name '-' textmeasure ': ' 'average connectivity above threshold']);
figure_temp=['Lines-' textmeasure '- ' 'average connectivity thr' name];saveas(gcf, figure_temp, 'fig')
clear figure_temp 

clear average_pos threshold


%% 
% DEFINE LIST WITH 10 or 15 (Crank) MOST ACTIVE ELECTRODE COUPLES 


average_pos2=tril(average,-1); % LOWER LEFT diagonal of 
crank=15;
[Megisti,ind]=sort(average_pos2(:),'descend');
Megisti = Megisti(1:crank); ind=ind(1:crank);
[row col] = ind2sub(size(average_pos2),ind);
couple={};

% create the list with the most active electrode couples
for k=1:crank, couple{k}=[s{row(k)} '-' s{col(k)}]; end;
DTF.couple=couple;

% this is the values of the correlation coefficient for the most active
% channels
for kk=1:crank, couple_values(kk)=Megisti(kk); end;
DTF.couple_values=couple_values;

% % ???Sum all the 'contributions' to all channels
% sum_sleep_all=sum(sleep_average_pos,1);
clear Megisti row col k sleep_average_pos2 kk ind

% Send the results to excel file 
stempp=['MostCouples- ' textmeasure]; % do not delete this!!!!
xlswrite(stempp, name, 'Sheet1', 'A1:A1')
titles={'Sleep', 'awake'};
xlswrite(stempp, (titles{1}), 'Sheet1', 'A2:A2')
xlswrite(stempp,couple, 'Sheet1', 'B2')
xlswrite(stempp,couple_values, 'Sheet1', 'B3')
% END SLEEP 
%% 
save DTF DTF



