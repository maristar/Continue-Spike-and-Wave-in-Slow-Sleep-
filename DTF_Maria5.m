 %% DTF computation 3-5-2011
thismoment=datestr(now);
for jj=1:length(thismoment); if ( thismoment(jj)==':' || thismoment(jj)==' '); thismoment(jj)='-';end; end
resultscor.now=thismoment;
 
dataf=resultscor.dataf;

nchan=size(dataf,1);
num_epochs=size(dataf,3);
low_freq=4;
high_freq=7;
p=20;
fs=200;
%DTF_epoch=zeros(num_epochs, nchan, nchan, 4);
% DTF calculation, 

%matlabpool(4)

tic
for jk=1:num_epochs
       ts=squeeze(dataf(:,:,jk))'; % 4000 x nchan
%        for cc=1:nchan
%            ts1(:,cc)=(ts(:,cc)-mean(ts(:,cc)))/std(ts(:,cc));
%        end
    gamma2 = DTF(ts,low_freq,high_freq,p,fs);  %% 10 x 10 x 4
    %plot(SBC,'DisplayName','SBC','YDataSource','SBC');figure(gcf); title(['chan ' B(ik)])
    gamma2_all(jk,:,:,:)=gamma2;
    gamma2=[];
end
toc/60
clear fs dataf jk ts gamma2 

for kk=1:nchan,
            gamma2_all(:,kk,kk,:)=0; %% set zero the diagonal elements 
     end
clear kk    
        
%% gamma = number of epochs x nchan x nchan x 4 (sink, source, frequency index)
% make averages for all epochs 
meanA=squeeze(mean(gamma2_all,1));
%load B10
stemp_dir=[thismoment 'DTF-order' num2str(p) '-freqs-' num2str(low_freq) 'to' num2str(high_freq)]
mkdir(stemp_dir)
cd(stemp_dir)
s=resultscor.s;
meanFreq=mean(meanA, 3);

gammaFreq=mean(gamma2_all,4);
% Create average DTF plots 
figure;imagesc(meanFreq);axis xy; 
set(gca, 'YTickLabel', s); set(gca, 'XTickLabel', s);
set(gca,'Ytick', 1:nchan); set(gca, 'XTick', 1:nchan);
colorbar('location','EastOutside');
title([' DTF: ' num2str(low_freq) '-' num2str(high_freq) ' Hz']); saveas(gcf, 'DTF', 'fig')
clear source
color_lim=caxis;


close all

%Create plots of interaction values through times for all pairs of
%electrodes
B=resultscor.s;
h=0;timeVec2=(1:num_epochs).*20/3600;
 for kl=1:nchan
     for kj=1:nchan
         if (kl~=kj)
             epoch_points_sink=squeeze(gamma2_all(:,kl,kj,1)); figure(h+3); 
             plot(timeVec2, epoch_points_sink, '*'); title([B(kl) '-' B(kj) 'DTF ' ]);axis tight;
             xlabel('time (hrs)'); YLim([0 1]);
             chan1=cell2mat(B(kl)); chan2=cell2mat(B(kj)); 
             stemp=['theta band DTF-' num2str(chan1)  '-' num2str(chan2)]; saveas(gcf, stemp, 'fig'); 
             close all;
                     %Sink(kl,kj,num_epochs,:)=epoch_points_sink;
             clear chan1 chan2 stemp epoch_points_sink onesz a
         end
     end
         
 end

Tgamma2_all=gamma2_all;
resultscor.TDTF=Tgamma2_all;
resultscor.gammaFreqT=gammaFreq;
save resultscor resultscor -v7.3

%matlabpool close
clear kl kj index_pool sink epoch_points_source epoch_points_sink



