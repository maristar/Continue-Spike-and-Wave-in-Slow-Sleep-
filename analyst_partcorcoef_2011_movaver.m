% Oslo 2010
% we need the dataset in format chan x datapoints and the names of the
% electrodes in the correct order in .mat

%% select the dataset to work on
clear all 
close all 
tic
[filename, pathname] = uigetfile('*.mat', 'Pick a MATLAB data file');
    if isequal(filename,0) || isequal(pathname,0)
       disp('User pressed cancel')
    else
       disp(['User selected ', fullfile(pathname, filename)])
    end
  % > out filename pathname
adata=load(filename);
data=adata.(filename(1:end-4)); % chan x time
data=double(data);% from eeglab it exits as single, so we have to double it.
% for j=1:size(data,1)
%     data(j,:)=(data(j,:)-mean(data(j,:)))/std(data(j,:))
% end
fs=input('Sampling frequency? ')
  
% keep in the same directory if not
street=pwd; if ~strcmp(street, pathname(1:end-1)), cd(pathname), end
  
 % clear memory
clear adata clear pathname street 

% load the matlab .mat file with the names of the electrodes
[filename2, pathname2] = uigetfile('*.mat', 'Pick the cell array with electrode namels file');
    if isequal(filename2,0) || isequal(pathname2,0)
       disp('User pressed cancel')
    else
       disp(['User selected ', fullfile(pathname2, filename2)])
    end
achan=load(filename2);
chan=achan.(filename2(1:end-6))%% it was 6 and i changed it to 4
s=chan;
clear chan achan filename2 pathname2
 
  %% make a 3 dimensional array out of it!
nchan=size(data,1);
NN=size(data,2);
epoch_duration=20;% sec
epoch_duration_dps=20*fs;
num_epochs=floor(NN/epoch_duration_dps);  %% theloume 20 seconds, 20sec*200dp/sec=4000
c=epoch_duration_dps*num_epochs;
data10n=data(:,1:c);
dataf=reshape(data10n,[nchan epoch_duration_dps num_epochs]); %data8n : nchan 4000 b
clear c b NN data10
save dataf dataf
%% function analysis 1 correlation coefficient
for k=1:num_epochs
    tempiii=dataf(1:nchan,:,k)'; %% it wants first the data points, then the number of channels
    result1(:,:,k)=partialcorr(tempiii);
    a1=squeeze(result1(:,:,k));
%       2-d PLOTS     
%     figure; imagesc(a1); set(gca,'Ytick', 1:nchan); set(gca, 'XTick', 1:nchan); set(gca, 'YTickLabel', s); set(gca, 'XTickLabel', s);
%     axis xy; axis tight; colorbar('location','EastOutside')
%    clear tempiii a1 

 end
clear k 
time_min=60    % in minutes, total time of wanted average information
time_pnts=time_min*60/epoch_duration % (time_min * 60 sec/min) / epoch duration  , in epoch points (every epoch is 20sec)
nn=floor(num_epochs/time_pnts)
timeVec3=(1:nn);
for kl=1:nchan
     for kj=1:nchan
         points=squeeze(result1(kl,kj,:));
        for k=1:(nn-1)
         chan_couple_aver(kl,kj,k)=[mean(points((k+(k*time_pnts)-time_pnts))  :(  k+( (k+1)*time_pnts )-time_pnts));];
        end
        aa=squeeze(chan_couple_aver(kl, kj, :));
        figure; plot(aa); title([s(kl) '-' s(kj) ' partial-correlation' ]);
        clear aa points
     end
end
%% Interactions Plots O1-F1
timeVec2=(1:num_epochs).*epoch_duration/3600;
h=0
 for kl=1:nchan
     for kj=1:nchan
         if (kl~=kj)
             h=h+1;
             index_pool{h,:}=[num2str(kj) num2str(kl)]
             a=strcmp(index_pool, [num2str(kl),num2str(kj)])
             onesz=find(a)
             if length(onesz)==0
                     points=squeeze(chan_couple_aver(kl,kj,:));
                     figure; plot(points); 
                     title([s(kl) '-' s(kj) ' partial-correlation jur08apr08' ]);
                      axis tight;
                      xlabel('time (hrs)'); 
                      %YLim([-1 1]);
                      chan1=cell2mat(s(kl)); 
                      chan2=cell2mat(s(kj)); 
                      stemp=['partial-correlation-60min-jur08apr08' num2str(chan1)  '-' num2str(chan2)]; 
                      saveas(gcf, stemp, 'fig'); 
                     end
             clear onesz a 
         end
         
     end
 end
 clear stemp index_pool % to rerun clear index_pool
 %% save results
 stemp=['partial-correlation-results' ];
 toc/60
 eval(['save ' stemp ' result1 timeVec2 s nchan num_epochs'])


