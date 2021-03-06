function [PC]=assymetry_index_pc(result1, timeTosleep, timeEndsleep, B, xyz, textmeasure, timeVec2, num_epochs, nchan,s, name, now)
textmeasure='Partial Correlation'; %input('measure:__','s');


%% Index sleep is when the child starts to sleep. We have to see that from the EEG file and-or the 
 
%timeTOsleep=12.3; %hrs
indexsleep=min(find((timeVec2>timeTosleep)));
result_pre=result1(:,:,1:indexsleep);

%timeTOendsleep=21.2;
indexendsleep=min(find((timeVec2>timeEndsleep)));
result_post=result1(:,:,(indexsleep+1):indexendsleep);

clear indexsleep indexendsleep timeTOsleep timeTOendsleep

%%  (B2) AVERAGE DURING AWAKE 

awake_average=mean(result_pre(:,:,1:end),3);
% plot 
figure;imagesc(awake_average);title([name '-' textmeasure ': ' 'average of awake ']);
set(gca,'Ytick', 1:nchan); set(gca, 'XTick', 1:nchan); 
set(gca, 'YTickLabel', s); set(gca, 'XTickLabel', s);
axis xy; axis tight; colorbar('location','EastOutside')
figure_temp=[textmeasure '- ' 'average of awake ' name]; saveas(gcf, figure_temp, 'fig')
PC.awakeaverage=awake_average;
clear figure_temp
plot2dhead(awake_average, xyz, B); title([name '-' textmeasure ': ' 'average of awake ']);
figure_temp=['Lines-' textmeasure '- ' 'average of awake ' name];saveas(gcf, figure_temp, 'fig')
clear figure_temp 
%% 
%  (B2B) AVERAGE DURING AWAKE ABOVE THRESHOLD 0.5 

awake_average_pos=zeros(nchan, nchan);
threshold_awake=max(max(tril(awake_average, -1)))/2;
for hh=1:nchan
    for kk=1:nchan
        if awake_average(kk,hh)>threshold_awake; %% this threshold could change depending on average resutls
            awake_average_pos(kk,hh)=awake_average(kk,hh);
        else
            awake_average_pos(kk,hh)=0;
        end
    end
end

clear hh kk 

% Plot
figure; imagesc(awake_average_pos);
title([name '-' textmeasure ': ''average of awake above threshold ' num2str(threshold_awake)]);
set(gca,'Ytick', 1:nchan); set(gca, 'XTick', 1:nchan); 
set(gca, 'YTickLabel', s); set(gca, 'XTickLabel', s);
axis xy; axis tight; colorbar('location','EastOutside');
figure_temp=[textmeasure '- ' 'average of awake above thr ' name]; saveas(gcf, figure_temp, 'fig')
PC.awakeaveragepos=awake_average_pos;
PC.awakethr=threshold_awake;

plot2dhead(awake_average_pos, xyz, B); title([name '-' textmeasure ': ''average of awake above threshold ' num2str(threshold_awake)]);
figure_temp=['Lines-' textmeasure '- ' 'average of awake above thr ' name]; saveas(gcf, figure_temp, 'fig')
clear awake_average_pos threshold_awake
%% 
% (B3) AVERAGE DURING SLEEP

sleep_average=mean(result_post(:,:,:),3);

% Plot
figure;imagesc(sleep_average);title([name '-' textmeasure ': ''average of sleep ']);
set(gca,'Ytick', 1:nchan); set(gca, 'XTick', 1:nchan); set(gca, 'YTickLabel', s); set(gca, 'XTickLabel', s);
axis xy; axis tight; colorbar('location','EastOutside');
figure_temp=[textmeasure '- ' 'average of sleep ' name]; saveas(gcf, figure_temp, 'fig')
PC.sleepaverage=sleep_average;

plot2dhead(sleep_average, xyz, B);title([name '-' textmeasure ': average of sleep ']);
figure_temp=['Lines-' textmeasure '- ' 'average of sleep ' name]; saveas(gcf, figure_temp, 'fig')
%% 
% (B3B) AVERAGE DURING SLEEP ABOVE THRESHOLD 0,5
threshold_sleep=max(max(tril(sleep_average, -1)))/2;
sleep_average_pos=zeros(nchan, nchan);
for hh=1:nchan
    for kk=1:nchan
        
        if sleep_average(kk,hh)>threshold_sleep; %% this threshold could change depending on average resutls
            sleep_average_pos(kk,hh)=sleep_average(kk,hh);
        else
            sleep_average_pos(kk,hh)=0;
        end
    end
end

PC.sleepavgpos=sleep_average_pos;
% Plot
figure; imagesc(sleep_average_pos);
title([name '-' textmeasure ': ' 'average of sleep above threshold ' num2str(threshold_sleep)]);
set(gca,'Ytick', 1:nchan); set(gca, 'XTick', 1:nchan); 
set(gca, 'YTickLabel', s); set(gca, 'XTickLabel', s);
axis xy; axis tight; colorbar('location','EastOutside');
figure_temp=[textmeasure '- ' 'average of sleep above thr ' name]; saveas(gcf, figure_temp, 'fig')

plot2dhead(sleep_average_pos, xyz, B);title([name '-' textmeasure ':' 'average of sleep above threshold ' num2str(threshold_sleep)]);
figure_temp=['Lines-' textmeasure '-' 'average of sleep above thr ' name]; saveas(gcf, figure_temp, 'fig')
clear sleep_average_pos hh kk threshold_awake

%% (B4)
% DEFINE LIST WITH 10 or 15 (Crank) MOST ACTIVE ELECTRODE COUPLES 
% SLEEP 

sleep_average_pos2=tril(sleep_average,-1); % LOWER LEFT diagonal of 
crank=45;
[Megisti,ind]=sort(sleep_average_pos2(:),'descend');
Megisti = Megisti(1:crank); ind=ind(1:crank);
[row col] = ind2sub(size(sleep_average_pos2),ind);
couple_sleep={};

% create the list with the most active electrode couples
for k=1:crank, couple_sleep{k}=[s{row(k)} '-' s{col(k)}]; end;
PC.couple_sleep=couple_sleep;

% this is the values of the correlation coefficient for the most active
% channels
for kk=1:crank, couple_sleep_values(kk)=Megisti(kk); end;
PC.couple_sleep_values=couple_sleep_values;

% % ???Sum all the 'contributions' to all channels
% sum_sleep_all=sum(sleep_average_pos,1);
clear Megisti row col k sleep_average_pos2 kk ind

% Send the results to excel file 
stempp=[now '-MostCouples-' textmeasure]; % do not delete this!!!!
xlswrite(stempp, name, 'Sheet1', 'A1:A1')
titles={'Sleep', 'awake'};
xlswrite(stempp, (titles{1}), 'Sheet1', 'A2:A2')
xlswrite(stempp,couple_sleep, 'Sheet1', 'B2')
xlswrite(stempp,couple_sleep_values, 'Sheet1', 'B3')
% END SLEEP 
%% (B5)
% DEFINE LIST WITH 10 MOST ACTIVE ELECTRODE COUPLES 
% AWAKE  from the awake average 

awake_average_pos2=tril(awake_average,-1); % LOWER LEFT diagonal of 
crank=45;
[Megisti,ind]=sort(awake_average_pos2(:),'descend');
Megisti = Megisti(1:crank); ind=ind(1:crank);
[row col] = ind2sub(size(awake_average_pos2),ind);
couple_awake={};

% create the list with the most active electrode couples
for k=1:crank, couple_awake{k}=[s{row(k)} '-' s{col(k)}]; end
PC.couple_awake=couple_awake;

% this is the values of the correlation coefficient for the most active
% channels
for kk=1:crank, couple_awake_values(kk)=Megisti(kk); end;
PC.couple_awake_values=couple_awake_values;

% Send the results to the excel file 
xlswrite(stempp, titles{2}, 'Sheet1', 'A4:A4')
xlswrite(stempp,couple_awake, 'Sheet1', 'B4');
xlswrite(stempp,couple_awake_values, 'Sheet1', 'B5');

% make this kind of sum 
% sum_awake_all=sum(awake_average_pos,1);
%  [a indi]=sort(sum_awake_all, 'descend');
%  s{indi(1:3)};

clear Megisti col k kk row ind awake_average_pos2
%% (B6)
%  DIFFERENCES & DEFINE THE LIST WITH MOST ACTIVE COUPLES 
% AWAKE - SLEEP 
difwk_sl=awake_average-sleep_average; % awake-sleep
figure; imagesc(difwk_sl); title([textmeasure ': ' ' awake - sleep '])
set(gca,'Ytick', 1:nchan); set(gca, 'XTick', 1:nchan); set(gca, 'YTickLabel', s); set(gca, 'XTickLabel', s);
axis xy; axis tight; colorbar('location','EastOutside');
PC.awake_sleep=difwk_sl;

% which are the 15 first 
diff_awake_sleep=tril(difwk_sl,-1);
[Megisti, ind]=sort(diff_awake_sleep(:),'descend');
Megisti=Megisti(1:crank);
ind=ind(1:crank);
[row col]=ind2sub(size(diff_awake_sleep), ind);
couple_diff_awake_sleep={};
for k=1:crank, couple_diff_awake_sleep{k}=[s{row(k)} '-' s{col(k)}];end

PC.couple_diff_awake_sleep=couple_diff_awake_sleep;

% this is the values of the correlation coefficient for the most active
% channels
for kk=1:crank, couple_diff_awake_sleep_values(kk)=Megisti(kk); end;

% save results in structure
PC.diff_couple_awak_sl_values=couple_diff_awake_sleep_values;

% write them to excel
xlswrite(stempp,couple_diff_awake_sleep, 'Sheet1', 'B6');
xlswrite(stempp,couple_diff_awake_sleep_values, 'Sheet1', 'B7');
clear Megisti col row kk k ind couple_diff_awake_sleep diff_awake_sleep difwk_sl
%%  
%  (B7) Differences between SLEEP -AWAKE
% 
difsl_wk=sleep_average-awake_average; % sleep - awake
% plot
figure; imagesc(difsl_wk); title([textmeasure ': ' ' sleep - awake ']);
set(gca,'Ytick', 1:nchan); set(gca, 'XTick', 1:nchan); set(gca, 'YTickLabel', s); set(gca, 'XTickLabel', s);
axis xy; axis tight; colorbar('location','EastOutside');
% save in structure
PC.sleep_awake=difsl_wk;

% which are the 15 first 
diff_sleep_awake=tril(difsl_wk,-1);
[Megisti, ind]=sort(difsl_wk(:), 'descend');
Megisti=Megisti(1:crank);
ind=ind(1:crank);
[row col]=ind2sub(size(diff_sleep_awake), ind);

couple_diff_sleep_awake={};
for k=1:crank, couple_diff_sleep_awake{k}=[s{row(k)} '-' s{col(k)}];end;

for kk=1:crank, couple_diff_sleep_awake_values(kk)=Megisti(kk); end
% save
PC.couple_diff_sleep_awake=couple_diff_sleep_awake;
PC.couple_diff_sleep_awake_values=couple_diff_sleep_awake_values;

%print to excel
xlswrite(stempp,couple_diff_sleep_awake, 'Sheet1', 'B8');
xlswrite(stempp,couple_diff_sleep_awake_values, 'Sheet1', 'B9');
clear Megisti col row kk k ind couple_diff_sleep_awake_values couple_diff_sleep_awake difwk_sl

% plot only those with increase during sleep more than half the max value
difsl_wk_pos=zeros(nchan, nchan);
for hh=1:nchan
    for kk=1:nchan
        max1=max(max(difsl_wk))/2;
        if difsl_wk(kk,hh)>max1; %% this threshold could change depending on average resutls
            difsl_wk_pos(kk,hh)=difsl_wk(kk,hh);
        else
            difsl_wk_pos(kk,hh)=0;
        end
    end
end
PC.sleep_awake_thr=difsl_wk_pos;

%save all the PC structure
save PC PC -v7.3


figure;imagesc(difsl_wk_pos); title([textmeasure ': ' ' sleep - awake above threshold ']);
set(gca,'Ytick', 1:nchan); set(gca, 'XTick', 1:nchan); set(gca, 'YTickLabel', s); set(gca, 'XTickLabel', s);
axis xy; axis tight; colorbar('location','EastOutside');

