 %% DTF computation 20-12-2010
clear all 
close all
fs=200;t=1:1/fs:2000; 
a=sin(2*pi*(t+5/fs)*10)+0.8*randn(1,length(t)); 
dela=sin(2*pi*10*t);
delb=sin(2*pi*(t+10/fs)*10)+0.8*randn(1,length(t));

figure;plot(a(1:200),'r');hold on; plot(dela(1:200),'g'); hold on; plot(delb(1:200))

dataf1=[a; dela; delb];
% load dataf1
dataf=dataf1;
clear dataf1
nchan=size(dataf,1);
num_epochs=size(dataf,3);
low_freq=8;
high_freq=12;
p=16;
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
    gamma2_all(:,:,:)=gamma2;
    %   gamma2_all(jk,:,:,:)=gamma2;   'BECAUSE WE HAVE 2 CHANNELS'
    %DTF_epoch(jk,:,:,:)=gamma2;
    %DTF_avg(jk,:,:,:)=DTF_epoch+DTF_avg;
end
toc/60
clear fs dataf jk ts gamma2 
%DTF_final=DTF_avg/num_epochs;
     for kk=1:nchan,
            gamma2_all(kk,kk,:)=0; %% set zero the diagonal elements 
     end
clear kk    
        
%% gamma = number of epochs x nchan x nchan x 4 (sink, source, frequency index)
meanA=gamma2_all;
%load B10
B={'a', 'del_a', 'delb'};
% Create average DTF source plots 
source=meanA(:,:,2);
figure;imagesc(source);axis xy;
set(gca, 'YTickLabel', B); set(gca, 'XTickLabel', B);
set(gca,'Ytick', 1:nchan); set(gca, 'XTick', 1:nchan);
colorbar('location','EastOutside');
title(' DTF: source'); 
saveas(gcf, 'DTF_source', 'fig')
clear source
color_lim=caxis;

% Create average DTF sink plots with same color limits as DTF source
sink=meanA(:,:,1);
figure;imagesc(sink, color_lim);axis xy; 
set(gca, 'YTickLabel', B); set(gca, 'XTickLabel', B);
set(gca,'Ytick', 1:nchan); set(gca, 'XTick', 1:nchan);
colorbar('location','EastOutside');title('DTF :sink'); saveas(gcf, 'DTF_sink', 'fig')
clear sink kk color_lim


close all

%Create plots of interaction values through times for all pairs of
%electrodes
h=0;timeVec2=(1:num_epochs).*20/3600;
 for kl=1:nchan
     for kj=1:nchan
         if (kl~=kj)
             epoch_points_sink=squeeze(gamma2_all(kl,kj,1)); figure(h+3); plot(timeVec2, epoch_points_sink, '*'); title([B(kl) '-' B(kj) 'DTF sink' ]);axis tight;xlabel('time (hrs)'); YLim([0 1]);
             chan1=cell2mat(B(kl)); chan2=cell2mat(B(kj)); stemp=['DTFsink-' num2str(chan1)  '-' num2str(chan2) 'freq' num2str(low_freq) '-' num2str(high_freq)]; saveas(gcf, stemp, 'fig'); close all;
                     %Sink(kl,kj,num_epochs,:)=epoch_points_sink;
             clear chan1 chan2 stemp epoch_points_sink onesz a
                    
                     %
                     %the same for source
             epoch_points_source=squeeze(gamma2_all(kl,kj,2)); figure(h+4); plot(timeVec2, epoch_points_source, '*'); title([B(kl) '-' B(kj) 'DTF source' ]);axis tight;xlabel('time (hrs)'); YLim([0 1]);
             chan1=cell2mat(B(kl)); chan2=cell2mat(B(kj)); stemp=['DTFsource-' num2str(chan1)  '-' num2str(chan2) 'freq' num2str(low_freq) '-' num2str(high_freq)]; saveas(gcf, stemp, 'fig'); close all;
                     %Source(kl,kj,num_epochs,:)=epoch_points_source;
             clear chan1 chan2 stemp epoch_points_source
         end
     end
         
 end
clear kl kj index_pool sink epoch_points_source epoch_points_sink
save DTF_results gamma2_all meanA timeVec2 B p


