%function [difsl_wk,difsl_wk_pos]=Assymetry_index(result_cor, timeVec2, s, timeTosleep)
% after partial correlation 29-3-2011
%% Load results from correlation
tic
%load resultscor
toc
textmeasure='DTF'; %input('measure:__','s');
result1=resultscor.gammaFreqT; %%usually it is resultscor.correlation partcor
s=resultscor.s;
timeVec2=resultscor.timevec2; %% usually it is timeVec2, in KLe it is timevec2
nchan=resultscor.nchan;

%% Index sleep is when the child starts to sleep. We have to see that from the EEG file and-or the 
% partial/ correlation plots. The same for the time that sleep ends. So we
% separate the results of correlation into awake and sleep. 
timeTOsleep=12.3; %hrs
indexsleep=find(timeVec2==timeTOsleep);
result_pre=result1(1:indexsleep,:,:);

timeTOendsleep=21.2;
indexendsleep=min(find((timeVec2>timeTOendsleep)));
result_post=result1((indexsleep+1):indexendsleep,:,:);

clear indexsleep indexendsleep timeTOsleep timeTOendsleep
% NOTICE: hau timeTosleep=12.3, endsleep=21.2
% NOTICE jur08apr08 timeTOsleep 8.5 endsleep=18.5
% Notice KLe 9.18 - 19.15
% Notice Rau14aug07 12 - 22,5
% Notice Hol 11.5 - 22.16
%% 
%  AVERAGE DURING AWAKE 

awake_average=squeeze(mean(result_pre(:,:,:),1));
% plot 
figure;imagesc(awake_average);title([textmeasure ': ' 'average of awake ']);
set(gca,'Ytick', 1:nchan); set(gca, 'XTick', 1:nchan); 
set(gca, 'YTickLabel', s); set(gca, 'XTickLabel', s);
axis xy; axis tight; colorbar('location','EastOutside')
resultscor.DTF_T_awakeaverage=awake_average;

 
%% 
% AVERAGE DURING AWAKE ABOVE THRESHOLD 0.5 

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
title([textmeasure ': ''average of awake above threshold ' num2str(threshold_awake)]);
set(gca,'Ytick', 1:nchan); set(gca, 'XTick', 1:nchan); 
set(gca, 'YTickLabel', s); set(gca, 'XTickLabel', s);
axis xy; axis tight; colorbar('location','EastOutside');
resultscor.DTF_T_awakeaveragepos=awake_average_pos;
resultscor.DTF_T_awakethr=threshold_awake;

clear awake_average_pos threshold_awake
%% 
% AVERAGE DURING SLEEP

sleep_average=squeeze(mean(result_post(:,:,:),1));

% Plot
figure;imagesc(sleep_average);title([textmeasure ': ''average of sleep ']);
set(gca,'Ytick', 1:nchan); set(gca, 'XTick', 1:nchan); set(gca, 'YTickLabel', s); set(gca, 'XTickLabel', s);
axis xy; axis tight; colorbar('location','EastOutside');

resultscor.DTF_T_sleepaverage=sleep_average;

%% 
% AVERAGE DURING SLEEP ABOVE THRESHOLD 0,5
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


resultscor.DTF_T_sleepavgpos=sleep_average_pos;
% Plot
figure; imagesc(sleep_average_pos);
title([textmeasure ': ' 'average of sleep above threshold ' num2str(threshold_sleep)]);
set(gca,'Ytick', 1:nchan); set(gca, 'XTick', 1:nchan); 
set(gca, 'YTickLabel', s); set(gca, 'XTickLabel', s);
axis xy; axis tight; colorbar('location','EastOutside');

clear sleep_average_pos hh kk threshold_awake

%% 
% DEFINE LIST WITH 10 or 15 (Crank) MOST ACTIVE ELECTRODE COUPLES 
% SLEEP 

sleep_average_pos2=tril(sleep_average,-1); % LOWER LEFT diagonal of 
crank=15;
[Megisti,ind]=sort(sleep_average_pos2(:),'descend');
Megisti = Megisti(1:crank); ind=ind(1:crank);
[row col] = ind2sub(size(sleep_average_pos2),ind);
couple_sleep={};

% create the list with the most active electrode couples
for k=1:crank, couple_sleep{k}=[s{row(k)} '-' s{col(k)}]; end;
resultscor.DTF_T_couple_sleep=couple_sleep;

% this is the values of the correlation coefficient for the most active
% channels
for kk=1:crank, couple_sleep_values(kk)=Megisti(kk); end;
resultscor.DTF_T_couple_sleep_values=couple_sleep_values;

% % ???Sum all the 'contributions' to all channels
% sum_sleep_all=sum(sleep_average_pos,1);
clear Megisti row col k sleep_average_pos2 kk ind

% Send the results to excel file 
stempp=[resultscor.now '-MostCouples']; % do not delete this!!!!
xlswrite(stempp, resultscor.filename, 'Sheet1', 'A1:A1')
titles={'Sleep', 'awake'};
xlswrite(stempp, (titles{1}), 'Sheet1', 'A2:A2')
xlswrite(stempp,couple_sleep, 'Sheet1', 'B2')
xlswrite(stempp,couple_sleep_values, 'Sheet1', 'B3')
% END SLEEP 
%% 
% DEFINE LIST WITH 10 MOST ACTIVE ELECTRODE COUPLES 
% AWAKE  from the awake average 

awake_average_pos2=tril(awake_average,-1); % LOWER LEFT diagonal of 
crank=15;
[Megisti,ind]=sort(awake_average_pos2(:),'descend');
Megisti = Megisti(1:crank); ind=ind(1:crank);
[row col] = ind2sub(size(awake_average_pos2),ind);
couple_awake={};

% create the list with the most active electrode couples
for k=1:crank, couple_awake{k}=[s{row(k)} '-' s{col(k)}]; end
resultscor.DTF_T_couple_awake=couple_awake;

% this is the values of the correlation coefficient for the most active
% channels
for kk=1:crank, couple_awake_values(kk)=Megisti(kk); end;
resultscor.DTF_T_couple_awake_values=couple_awake_values;

% Send the results to the excel file 
xlswrite(stempp, titles{2}, 'Sheet1', 'A4:A4')
xlswrite(stempp,couple_awake, 'Sheet1', 'B4');
xlswrite(stempp,couple_awake_values, 'Sheet1', 'B5');

% make this kind of sum 
% sum_awake_all=sum(awake_average_pos,1);
%  [a indi]=sort(sum_awake_all, 'descend');
%  s{indi(1:3)};

clear Megisti col k kk row ind awake_average_pos2
%% 
%  DIFFERENCES & DEFINE THE LIST WITH MOST ACTIVE COUPLES 
% AWAKE - SLEEP 
difwk_sl=awake_average-sleep_average; % awake-sleep
figure; imagesc(difwk_sl); title([textmeasure ': ' ' awake - sleep '])
set(gca,'Ytick', 1:nchan); set(gca, 'XTick', 1:nchan); set(gca, 'YTickLabel', s); set(gca, 'XTickLabel', s);
axis xy; axis tight; colorbar('location','EastOutside');
resultscor.DTF_T_awake_sleep=difwk_sl;

% which are the 15 first 
diff_awake_sleep=tril(difwk_sl,-1);
[Megisti, ind]=sort(diff_awake_sleep(:),'descend');
Megisti=Megisti(1:crank);
ind=ind(1:crank);
[row col]=ind2sub(size(diff_awake_sleep), ind);
couple_diff_awake_sleep={};
for k=1:crank, couple_diff_awake_sleep{k}=[s{row(k)} '-' s{col(k)}];end

resultscor.DTF_T_couple_diff_awake_sleep=couple_diff_awake_sleep;

% this is the values of the correlation coefficient for the most active
% channels
for kk=1:crank, couple_diff_awake_sleep_values(kk)=Megisti(kk); end;

% save results in structure
resultscor.DTF_T_diff_couple_awak_sl_values=couple_diff_awake_sleep_values;

% write them to excel
xlswrite(stempp,couple_diff_awake_sleep, 'Sheet1', 'B6');
xlswrite(stempp,couple_diff_awake_sleep_values, 'Sheet1', 'B7');
clear Megisti col row kk k ind couple_diff_awake_sleep diff_awake_sleep difwk_sl
%%  
%  Differences between SLEEP -AWAKE
% 
difsl_wk=sleep_average-awake_average; % sleep - awake
% plot
figure; imagesc(difsl_wk); title([textmeasure ': ' ' sleep - awake ']);
set(gca,'Ytick', 1:nchan); set(gca, 'XTick', 1:nchan); set(gca, 'YTickLabel', s); set(gca, 'XTickLabel', s);
axis xy; axis tight; colorbar('location','EastOutside');
% save in structure
resultscor.DTF_T_sleep_awake=difsl_wk;

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
resultscor.DTF_T_couple_diff_sleep_awake=couple_diff_sleep_awake;
resultscor.DTF_T_couple_diff_sleep_awake_values=couple_diff_sleep_awake_values;

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
resultscor.DTF_T_sleep_awake_thr=difsl_wk_pos;

%save all the resultscor structure
save resultscor resultscor -v7.3


figure;imagesc(difsl_wk_pos); title([textmeasure ': ' ' sleep - awake above threshold ']);
set(gca,'Ytick', 1:nchan); set(gca, 'XTick', 1:nchan); set(gca, 'YTickLabel', s); set(gca, 'XTickLabel', s);
axis xy; axis tight; colorbar('location','EastOutside');

