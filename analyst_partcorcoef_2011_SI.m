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
clear adata pathname street fs

% load the matlab .mat file with the names of the electrodes
[filename2, pathname2] = uigetfile('*.mat', 'Pick the cell array with electrode names file');
    if isequal(filename2,0) || isequal(pathname2,0)
       disp('User pressed cancel')
    else
       disp(['User selected ', fullfile(pathname2, filename2)])
    end
achan=load(filename2);
chan=achan.(filename2(1:end-4))%% it was 6 and i changed it to 4
s=chan;
clear chan achan filename2 pathname2
 
  %% make a 3 dimensional array out of it!
nchan=size(data,1);
NN=size(data,2);
num_epochs=floor(NN/4000);  %% theloume 20 seconds, 20sec*200dp/sec=4000
c=4000*num_epochs;
data10n=data(:,1:c);
dataf=reshape(data10n,[nchan 4000 num_epochs]); %data8n : nchan 4000 b
clear c b NN data10
save dataf dataf
%% function analysis 1 correlation coefficient
for k=1:num_epochs
    tempiii=dataf(1:nchan,:,k)'; %% it wants first the data points, then the number of channels
    result1(:,:,k)=corrcoef(tempiii);
    a1=squeeze(result1(:,:,k));
%       2-d PLOTS     
%     figure; imagesc(a1); set(gca,'Ytick', 1:nchan); set(gca, 'XTick', 1:nchan); set(gca, 'YTickLabel', s); set(gca, 'XTickLabel', s);
%     axis xy; axis tight; colorbar('location','EastOutside')
%    clear tempiii a1 
 end
clear k 
% Interactions Plots O1-F1
load SIplot
load name
timeVec2=(1:num_epochs).*20/3600;
timeVecSI=(1:length(SIplot)).*600/3600;
h=0
 for kl=1:nchan
     for kj=1:nchan
         if (kl~=kj)
             h=h+1
             index_pool{h,:}=[num2str(kj) num2str(kl)]
             a=strcmp(index_pool, [num2str(kl),num2str(kj)])
             onesz=find(a)
             if length(onesz)==0
                     points=squeeze(result1(kl,kj,:)); figure; plot(timeVec2, points, '*'); title([name s(kl) '-' s(kj) 'partial-correlation' ]);axis tight;xlabel('time (hrs)'); YLim([-1 1]);
                     hold on; plor(timeVecSI, SIplot, 'r', 'LineWidth', 2)
                     chan1=cell2mat(s(kl)); chan2=cell2mat(s(kj)); stemp=['SI partial-correlation-' num2str(chan1)  '-' num2str(chan2)]; saveas(gcf, stemp, 'fig'); 
                     
             end
             clear onesz a 
         end
         
     end
 end
 clear stemp
 stemp=['partial-correlation-results' ];
 toc/60
 eval(['save ' stemp ' result1 timeVec2 s nchan num_epochs'])


