% after partial correlation 
%% first prerequisitives 



load correlation_results_csd
result1=result_cor;
s=B;

%% Index sleep is when the sleep starts. We have to see that from the 
%% partial correlation plots
indexsleep=find(timeVec2==10)
result_pre=result1(:,:,1:indexsleep);
result_post=result1(:,:,(indexsleep+1):end);

% awake_sum=sum(result_pre,3);
% figure;imagesc(awake_sum);title('sum of awake')
% set(gca,'Ytick', 1:nchan); set(gca, 'XTick', 1:nchan); set(gca, 'YTickLabel', s); set(gca, 'XTickLabel', s);
% axis xy; axis tight; colorbar('location','EastOutside')
% 
% sleep_sum=sum(result_post,3);
% figure; imagesc(sleep_sum);title('sum of sleep ')
% set(gca,'Ytick', 1:nchan); set(gca, 'XTick', 1:nchan); set(gca, 'YTickLabel', s); set(gca, 'XTickLabel', s);
% axis xy; axis tight; colorbar('location','EastOutside')


awake_average=mean(result_pre,3);
figure;imagesc(awake_average);title('average of awake ');
set(gca,'Ytick', 1:nchan); set(gca, 'XTick', 1:nchan); 
set(gca, 'YTickLabel', s); set(gca, 'XTickLabel', s);
axis xy; axis tight; colorbar('location','EastOutside')
save awake_average awake_average

sleep_average=mean(result_post,3);
figure;imagesc(sleep_average);title('average of sleep ')
set(gca,'Ytick', 1:nchan); set(gca, 'XTick', 1:nchan); set(gca, 'YTickLabel', s); set(gca, 'XTickLabel', s);
axis xy; axis tight; colorbar('location','EastOutside')
save sleep_average sleep_average

difwk_sl=awake_average-sleep_average; % awake-sleep
figure; imagesc(difwk_sl); title(' awake - sleep ')
set(gca,'Ytick', 1:nchan); set(gca, 'XTick', 1:nchan); set(gca, 'YTickLabel', s); set(gca, 'XTickLabel', s);
axis xy; axis tight; colorbar('location','EastOutside')


difsl_wk=sleep_average-awake_average; % sleep - awake
figure; imagesc(difsl_wk); title(' sleep - awake ')
set(gca,'Ytick', 1:nchan); set(gca, 'XTick', 1:nchan); set(gca, 'YTickLabel', s); set(gca, 'XTickLabel', s);
axis xy; axis tight; colorbar('location','EastOutside')
save difsl_wk difsl_wk
save difwk_sl difwk_sl

% plot only those with increase during sleep more than half the max value
for hh=1:nchan
    for kk=1:nchan
        max1=max(max(difsl_wk))/2;
        if difsl_wk(kk,hh)>max1 %% this threshold could change depending on average resutls
            difsl_wk_pos(kk,hh)=difsl_wk(kk,hh);
        else
            difsl_wk_pos(kk,hh)=0;
        end
    end
end
save difsl_wk_pos difsl_wk_pos
figure;imagesc(difsl_wk_pos); title(' sleep - awake above threshold ')
set(gca,'Ytick', 1:nchan); set(gca, 'XTick', 1:nchan); set(gca, 'YTickLabel', s); set(gca, 'XTickLabel', s);
axis xy; axis tight; colorbar('location','EastOutside')

%%
% % plot pairs of channels alone
% % C3-C4 are 3 - 4
% figure; plot([aa1(3,4) bb1(3,4)], '*');title('C3-C4 before and during sleep')
% xlim([0.5 2.5]);
% 
% %% P3-P4 is 4-5
% figure; plot([aa1(4,5) bb1(4,5)], '*');title('p3-p4 before and during sleep')
% xlim([0.5 2.5]);
% 
% channel1=input{'number of channel1... '}
% channel2=input('number of channel2... ')
% figure; plot([aa1(channel1,channel2) bb1(channel1,channel2)], '*');xlim([0.5 2.5]);
% stemp=[s{channel1} '-' s{channel2} ' before and during sleep'];
% title(stemp)
% xlim([0.5 2.5]);

% %% Select the two couples to calculate assymetry index
% experiment={};
% repeats=input('for how many times (number of 4couples to check) ')
% for q=1:repeats
%     for i=1:2
%         sout=['Input Couple 1 Channel ' num2str(i) '      '];
%         ss=input(sout,'s');
%         ss=upper(ss);
%         stest{i}=ss;
%     end
%     for i=1:2
%         sout=['Input Couple 2 Channel ' num2str(i) '      '];
%         ss=input(sout,'s');
%         stest{i+2}=upper(ss);
%     end
%     experiment{q}.stest=stest;
%     hit=0;
%     for jj=1:length(stest)
%         for k=1:nchan
%          a=strcmp(stest(jj),s{k});
%             if a>0
%                 hit=hit+1;
%                 channel(hit)=k; 
%             end
%             clear a
%         end
%     end
%     if length(channel)<4
%         disp('Could not find channel')
%     else
%         clear i jj sout ss hit
%         experiment{q}.channel=channel;
%         for kk=1:length(channel)
%             couple1=squeeze(awake_average(channel(1), channel(2),:));
%             couple2=squeeze(awake_average(channel(3), channel(4),:));
%             Assymetry_index_awake(q)=(couple1-couple2);
%         end
%         clear kk couple1 couple2
%         for kk=1:length(channel)
%             couple1=squeeze(sleep_average(channel(1), channel(2),:));
%             couple2=squeeze(sleep_average(channel(3), channel(4),:));
%             Assymetry_index_sleep(q)=(couple1-couple2);
%         end
%         disp(Assymetry_index_awake(q))
%         disp(Assymetry_index_sleep(q))
%         experiment{q}.Assymetry_index_sleep=Assymetry_index_sleep(q);
%         experiment{q}.Assymetry_index_awake=Assymetry_index_awake(q);
%         persentage=(Assymetry_index_awake(q)-Assymetry_index_sleep(q))*100/Assymetry_index_awake(q);
%         experiment{q}.persentage=persentage;
%         %this percentage 
%     end % if all channels exist, the assymetry calculation
%     clear couple
% end % repeats 
% 
% filename=['assymetry_results_partcor_csd.txt']
% report_assymetry(filename,experiment)
% % clear Assymetry_index_awake Assymetry_index_sleep channel couple1 couple2 
% save experiment.mat experiment