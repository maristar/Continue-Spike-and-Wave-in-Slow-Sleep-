%function [difsl_wk,difsl_wk_pos]=Assymetry_index(result_cor, timeVec2, s, timeTosleep)
% after partial correlation 29-3-2011
%% first prerequisitives, load results from correlation-partial correlation or other connectivity measure

load results
result1=results.correlation;
s=results.s;
timeVec2=results.timeVec2;
nchan=results.nchan;
clear results 
% clear results
%% Index sleep is when the child start to sleep. We have to see that from the EEG file and-or the 
%% partial/ correlation plots
timeTOsleep=12.3; %hrs
indexsleep=find(timeVec2==timeTOsleep);
result_pre=result1(:,:,1:indexsleep);
result_post=result1(:,:,(indexsleep+1):end);

clear indexsleep timeTOsleep 
%% AVERAGE DURING AWAKE 
awake_average=mean(result_pre,3);
% Now we plot it 
figure;imagesc(awake_average);title('average of awake ');
set(gca,'Ytick', 1:nchan); set(gca, 'XTick', 1:nchan); 
set(gca, 'YTickLabel', s); set(gca, 'XTickLabel', s);
axis xy; axis tight; colorbar('location','EastOutside')
save awake_average awake_average

%% AVERAGE DURING AWAKE ABOVE 0.5 
awake_average_pos=zeros(nchan, nchan);
threshold_awake=0.5;
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
figure; imagesc(awake_average_pos);title(['average of awake above threshold ' num2str(threshold_awake)]);
set(gca,'Ytick', 1:nchan); set(gca, 'XTick', 1:nchan); 
set(gca, 'YTickLabel', s); set(gca, 'XTickLabel', s);
axis xy; axis tight; colorbar('location','EastOutside');
save awake_average awake_average;

%% AVERAGE DURING SLEEP
sleep_average2=mean(result_post(:,:,1000:1500),3);
% Plot
figure;imagesc(sleep_average2);title('average of sleep ');
set(gca,'Ytick', 1:nchan); set(gca, 'XTick', 1:nchan); set(gca, 'YTickLabel', s); set(gca, 'XTickLabel', s);
axis xy; axis tight; colorbar('location','EastOutside');
save sleep_average sleep_average;

%% AVERAGE DURING sleep ABOVE 0 
sleep_average=sleep_average2;
sleep_average_pos=zeros(nchan, nchan);
for hh=1:nchan
    for kk=1:nchan
        threshold_awake=0.5;
        if sleep_average(kk,hh)>threshold_awake; %% this threshold could change depending on average resutls
            sleep_average_pos(kk,hh)=sleep_average(kk,hh);
        else
            sleep_average_pos(kk,hh)=0;
        end
    end
end

% Plot
figure; imagesc(sleep_average_pos);title(['average of sleep above threshold ' num2str(threshold_awake)]);
set(gca,'Ytick', 1:nchan); set(gca, 'XTick', 1:nchan); 
set(gca, 'YTickLabel', s); set(gca, 'XTickLabel', s);
axis xy; axis tight; colorbar('location','EastOutside');
save sleep_average sleep_average;

%% DEFINE LIST WITH 10 or 15 MOST ACTIVE ELECTRODE COUPLES SLEEP
%% SLEEP SLEEP SLEEP 
sleep_average_pos2=tril(sleep_average_pos,-1); % LOWER LEFT diagonal of 
crank=15;
[Megisti,ind]=sort(sleep_average_pos2(:),'descend');
Megisti = Megisti(1:crank); ind=ind(1:crank);
[row col] = ind2sub(size(sleep_average_pos2),ind);
couple_sleep={};

% create the list with the most active electrode couples
for k=1:crank, couple_sleep{k}=[s{row(k)} '-' s{col(k)}]; end;

% Sum all the 'contributions' to all channels
sum_sleep_all=sum(sleep_average_pos,1);

clear Megisti row col k
% Send the results to excel file MostCouples.xls, if this excel file does
% not exist it is created automatically

xlswrite('MostCouples.xls',couple_sleep, 'Sheet1', 'B1')
% END SLEEP 
%% DEFINE LIST WITH 10 MOST ACTIVE ELECTRODE COUPLES awake
% AWAKE AWAKE AWAKE 
awake_average_pos2=tril(awake_average_pos,-1); % LOWER LEFT diagonal of 
crank=15;
[Megisti,ind]=sort(awake_average_pos2(:),'descend');
Megisti = Megisti(1:crank); ind=ind(1:crank);
[row col] = ind2sub(size(awake_average_pos2),ind);
couple_awake={};
for k=1:crank, couple_awake{k}=[s{row(k)} '-' s{col(k)}]; end

couple_awake

 sum_awake_all=sum(awake_average_pos,1);
 [a indi]=sort(sum_awake_all, 'descend');
 s{indi(1:3)};
% for k=1:length(Megisti)
%     Megistos= max(Megisti); %We find the maximum value of all matrix
% 
%     index_Megistos=find(sleep_average_pos2==Megistos) % the max value is in order of matlab. So it is just a number we have 
% % to transform it to x,y coordinates
%     [row col] = ind2sub(size(sleep_average_pos), index_Megistos)
% %     couple{k}=([s{row{k}} '-' s{col{k}}])
%     value(k)=Megistos
%     Megisti(Megisti==Megistos)=0;
%     clear index_Megistos_f Megistos 
%     Megisti
% end
%%
%% DEFINE LIST WITH 10 MOST ACTIVE ELECTRODE COUPLES awake
awake_average_pos2=tril(awake_average_pos,-1); % LOWER LEFT diagonal of 

Megisti=max(awake_average_pos2);% we have now a row with the maxs of each colum px  0.5049    0.2094    0.1879    0.3285    0.2214    0.0743    0.2558    0.2865    0.0586         0

for k=1:length(Megisti)
    Megistos= max(Megisti); %We find the maximum value of all matrix

    index_Megistos=find(awake_average_pos2==Megistos); % the max value is in order of matlab. So it is just a number we have 
% to transform it to x,y coordinates
[row col] = ind2sub(size(awake_average_pos), index_Megistos);
    couple{k}=([s{row} '-' s{col}]);
    value(k)=Megistos;
    Megisti(Megisti==Megistos)=0;
    clear index_Megistos_f Megistos 
    Megisti
end
%% DIFFERENCES
% AWAKE - SLEEP 
difwk_sl=awake_average-sleep_average; % awake-sleep
figure; imagesc(difwk_sl); title(' awake - sleep ')
set(gca,'Ytick', 1:nchan); set(gca, 'XTick', 1:nchan); set(gca, 'YTickLabel', s); set(gca, 'XTickLabel', s);
axis xy; axis tight; colorbar('location','EastOutside');

% SLEEP -AWAKE
difsl_wk=sleep_average-awake_average; % sleep - awake
figure; imagesc(difsl_wk); title(' sleep - awake ');
set(gca,'Ytick', 1:nchan); set(gca, 'XTick', 1:nchan); set(gca, 'YTickLabel', s); set(gca, 'XTickLabel', s);
axis xy; axis tight; colorbar('location','EastOutside');
save difsl_wk difsl_wk;
save difwk_sl difwk_sl;

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
save difsl_wk_pos difsl_wk_pos;
figure;imagesc(difsl_wk_pos); title(' sleep - awake above threshold ');
set(gca,'Ytick', 1:nchan); set(gca, 'XTick', 1:nchan); set(gca, 'YTickLabel', s); set(gca, 'XTickLabel', s);
axis xy; axis tight; colorbar('location','EastOutside');

