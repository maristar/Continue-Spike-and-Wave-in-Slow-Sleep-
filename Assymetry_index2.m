% assymetry index 2
% OLD code backup
clear all
close all
nchan=10;load B10
s=B;num_epochs=size(result1,3)
timeVec2=(1:num_epochs).*20/3600;  % 20 sec is the epoch duration
% load result1 from partial correlation 
 for i=1:2
    sout=['Input Couple 1 Channel ' num2str(i) '      '];
    ss=input(sout,'s');
    stest{i}=ss;
 end
 for i=1:2
    sout=['Input Couple 2 Channel ' num2str(i) '      '];
    ss=input(sout,'s');
    stest{i+2}=ss;
 end
 
 hit=0;
for jj=1:length(stest)
    for k=1:nchan
        a=strcmp(stest(jj),s{k});
        if a>0
            hit=hit+1;
            channel(hit)=k; 
        end
        clear a
    end
end

clear i jj stest sout ss hit
for kk=1:length(channel)
    couple1=squeeze(result1(channel(1), channel(2),:));
    couple2=squeeze(result1(channel(3), channel(4),:));
    Assymetry_index=(couple1-couple2)/(couple1+couple2);
end
figure; plot(couple1, '*'); hold on; 
plot(couple2, '*r');
title(['blue' s(channel(1)) '-' s(channel(2)) ' >red' s(channel(3)) '-' s(channel(4))])

%%%

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
    



