function [COH]=assymetry_index_coh_ROC(connectivity_measure, timeTosleep, timeEndsleep, B, xyz, textmeasure, timeVec2, num_epochs, nchan,s, name, now, resultscot)
% 22-8-2011
 
%timeTOsleep=12.3; %hrs
indexsleep=min(find((timeVec2>timeTosleep)));
result_pre=connectivity_measure(:,:,1:indexsleep);

%timeTOendsleep=21.2;
indexendsleep=min(find((timeVec2>timeEndsleep)));
result_post=connectivity_measure(:,:,(indexsleep+1):indexendsleep);

%% plot partial correlation now
timeVec2=(1:num_epochs).*20/3600;
h=0;
clear index_pool kj kl 
index_pool={1:nchan*nchan}; %% to change this to the value of possible combinations
data_name=resultscor.filename(1:end-4);
s=resultscor.s;
 for kl=1:nchan
     for kj=1:nchan
         if (kl~=kj)
            h=h+1;
             index_pool{h,:}=[num2str(kj) num2str(kl)];
             a=strcmp(index_pool, [num2str(kl),num2str(kj)]);
             onesz=find(a);
             if isempty(onesz)
                awake1=squeeze(result_pre(kl,kj,:));   
                 sleep1=squeeze(result_post(kl,kj,:));
                 figure; subplot(2,1,1); hist(awake1);
                 title([data_name '-' s(kl) '-' s(kj) ' histogram for awake' ]);
                 subplot(2,1,2); hist(sleep1);
                 title([data_name '-' s(kl) '-' s(kj) ' histogram for sleep' ]);
                 %save image
                 chan1=cell2mat(s(kl)); chan2=cell2mat(s(kj)); 
                 stemp=['Histograms-' name '-' textmeasure '-' num2str(chan1)  '-' num2str(chan2)];
                 saveas(gcf, stemp, 'fig');
                 close all
                 [p,h] = signrank(awake1, sleep1);
                %[h,p,ci] =ttest2(awake1,sleep1,0.005,'both', 'unequal');
                 significance(kl,kj,:)=p;
                 h_value(kl,kj,:)=h;
                 clear awake1, sleep1, p, h
             end
             clear onesz a 
     end
 end
 end
 
for jj=1:nchan;
        h_value(jj,jj)=0;
        significance(jj,jj)=0;
end
 
 for kl=1:nchan
     for kj=1:nchan
         if significance(kl,kj)>0.005
             significance_plot(kl,kj)=0.051;
         else
             significance_plot(kl,kj)=0;
         end
     end
 end

figure; imagesc(h_value);
 set(gca,'Ytick', 1:nchan); set(gca, 'XTick', 1:nchan); 
set(gca, 'YTickLabel', s); set(gca, 'XTickLabel', s);
axis xy; axis tight; colorbar('location','EastOutside')
title('correlation h value')

 
figure; imagesc(significance_plot);
 set(gca,'Ytick', 1:nchan); set(gca, 'XTick', 1:nchan); 
set(gca, 'YTickLabel', s); set(gca, 'XTickLabel', s);
axis xy; axis tight; colorbar('location','EastOutside')
title('significance p value')
 
 clear chan1 chan2 cc h h1 k tempiii y points1 kj kl filename2 direct_temp
close all
cd ..

%% pool of awake
for k=1:nchan
    for h=1:nchan
        if (k~=h)
        pool_awake(:,:)=result_pre(k,h,:);
    end
end
end

%plot
 figure; hist(pool_awake);title ('pool of awake')
%% pool of sleep
for k=1:nchan
    for h=1:nchan
        if (k~=h)
        pool_sleep(:,:)=result_post(k,h,:);
    end
end
end

%plot
 figure; hist(pool_sleep);title ('pool of sleep')

clear indexsleep indexendsleep timeTOsleep timeTOendsleep
%save all the COH structure
save COH COH -v7.3


