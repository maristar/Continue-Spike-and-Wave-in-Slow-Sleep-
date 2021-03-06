function [COR]=assymetry_index_fl_coh(result1, B, xyz, textmeasure, timeVec2, num_epochs, nchan,s, name, now)
% after partial correlation 29-3-2011
%% (B1)Load results from correlation
%textmeasure='Correlation'; %input('measure:__','s');
% result1=resultscor.partcor; %%usually it is resultscor.correlation partcor
% s=resultscor.s;
% timeVec2=resultscor.timeVec2; %% usually it is timeVec2
% nchan=resultscor.nchan;


%  (B2) AVERAGE 

average=mean(result1(:,:,1:end),3);
% plot 
figure;imagesc(average);title([name '-' textmeasure ': ' 'average correlation']);
set(gca,'Ytick', 1:nchan); set(gca, 'XTick', 1:nchan); 
set(gca, 'YTickLabel', s); set(gca, 'XTickLabel', s);
axis xy; axis tight; colorbar('location','EastOutside')
figure_temp=[textmeasure '- ' 'average ' name]; saveas(gcf, figure_temp, 'fig')
COR.average=average;
clear figure_temp

figure; plot2dhead_fl(average, xyz, B); title([name '-' textmeasure ': ' 'average connectivity ']);
figure_temp=['Lines-' textmeasure '- ' 'average connectivity ' name];saveas(gcf, figure_temp, 'fig')
clear figure_temp 
%% 
%  (B2B) AVERAGE DURING AWAKE ABOVE THRESHOLD 0.5 

average_pos=zeros(nchan, nchan);
threshold=max(max(tril(average, -1)))/3;
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
title([name '-' textmeasure ': ''average connectivity above threshold ' num2str(threshold)]);
set(gca,'Ytick', 1:nchan); set(gca, 'XTick', 1:nchan); 
set(gca, 'YTickLabel', s); set(gca, 'XTickLabel', s);
axis xy; axis tight; colorbar('location','EastOutside');
figure_temp=[textmeasure '- ' 'average above thr ' name]; saveas(gcf, figure_temp, 'fig')
COR.awakeaveragepos=average_pos;
COR.awakethr=threshold;

figure; plot2dhead_fl(average_pos, xyz, B); title([name '-' textmeasure ': average connectivity above threshold ' num2str(threshold)]);
figure_temp=['Lines-' textmeasure '-average connectivity above thr ' name]; saveas(gcf, figure_temp, 'fig')
clear average_pos threshold


%% (B5)
% DEFINE LIST WITH 10 MOST ACTIVE ELECTRODE COUPLES 
%  from the awake average 

average_pos2=tril(average,-1); % LOWER LEFT diagonal of 
crank=15;
[Megisti,ind]=sort(average_pos2(:),'descend');
Megisti = Megisti(1:crank); ind=ind(1:crank);
[row col] = ind2sub(size(average_pos2),ind);
couple={};

% create the list with the most active electrode couples
for k=1:crank, couple{k}=[s{row(k)} '-' s{col(k)}]; end
COR.couple=couple;

% this is the values of the correlation coefficient for the most active
% channels
for kk=1:crank, couple_values(kk)=Megisti(kk); end;
COR.couple_values=couple_values;

% Send the results to the excel file 
stempp=['MostCouples-' textmeasure]; % do not delete this!!!!
xlswrite(stempp, name, 'Sheet1', 'A1:A1')
titles={'Sleep', 'awake'};
xlswrite(stempp, titles{2}, 'Sheet1', 'A4:A4')
xlswrite(stempp,couple, 'Sheet1', 'B4');
xlswrite(stempp,couple_values, 'Sheet1', 'B5');


save COR COR -v7.3


