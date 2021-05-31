%% DTF computation
load dataf
nchan=size(dataf,1);
num_epochs=size(dataf,3);
load B10
low_freq=4;
high_freq=7;
p=16;
fs=200;

 for jk=1:num_epochs
       ts=squeeze(dataf(:,:,jk))'; % 4000 x nchan
       for cc=1:nchan
           ts1(:,cc)=(ts(:,cc)-mean(ts(:,cc)))/std(ts(:,cc));
       end
      gamma2 = DTF(ts1,low_freq,high_freq,p,fs);  %% 10 x 10 x 4
    %plot(SBC,'DisplayName','SBC','YDataSource','SBC');figure(gcf); title(['chan ' B(ik)])
    gamma2_all(jk,:,:,:)=gamma2;
end

     for kk=1:nchan
        for jj=1:nchan
            if kk==jj,
                gamma2_all(kk,jj,:,:)=0;
            end
        end
     end
    
%% gamma = number of epochs x nchan x nchan x 4 (sink, source, frequency index)
meanA=squeeze(mean(gamma2_all,1));

sink=meanA(:,:,1);
figure;imagesc(sink);axis xy; 
set(gca, 'YTickLabel', B); set(gca, 'XTickLabel', B);
set(gca,'Ytick', 1:nchan); set(gca, 'XTick', 1:nchan);
colorbar('location','EastOutside');title('DTF :sink')

source=meanA(:,:,2);axis xy; figure;imagesc(source);axis xy; 
set(gca, 'YTickLabel', B); set(gca, 'XTickLabel', B);
set(gca,'Ytick', 1:nchan); set(gca, 'XTick', 1:nchan);
colorbar('location','EastOutside');
title(' DTF: source')

% figure;imagesc(gamma2(:,:,1))
% axis xy; 
% set(gca, 'YTickLabel', B); set(gca, 'XTickLabel', B);
% set(gca,'Ytick', 1:nchan); set(gca, 'XTick', 1:nchan);
% colorbar('location','EastOutside');


