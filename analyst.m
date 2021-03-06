% Oslo 2010
% select the dataset to work on
clear all 
close all 
[filename, pathname] = uigetfile('*.mat', 'Pick a MATLAB data file');
    if isequal(filename,0) || isequal(pathname,0)
       disp('User pressed cancel')
    else
       disp(['User selected ', fullfile(pathname, filename)])
    end
  % > out filename pathname
name=pathname(15:end-1);
 % load the matlab .mat file with the names of the electrodes
[filename2, pathname2] = uigetfile('*.mat', 'Pick the cell array with electrode namels file');
    if isequal(filename2,0) || isequal(pathname2,0)
       disp('User pressed cancel')
    else
       disp(['User selected ', fullfile(pathname2, filename2)])
    end
achan=load(filename2);
chan=achan.(filename2(1:end-4))%% it was 6 and i changed it to 4
s=chan;
clear chan achan filename2 pathname2
  
  
%s={'F3' 'F4' 'P3' 'P4' 'O1' 'O2' 'T5' 'T6'}
adata=load(filename);
data=adata.(filename(1:end-4)); % chan x time
data=double(data); % from eeglab it exits as single, so we have to double it.
fs=input('Sampling frequency? ')
  
% keep in the same directory if not
street=pwd; if ~strcmp(street, pathname(1:end-1)), cd(pathname), end
  
 % clear memory
clear adata clear pathname street fs
  
  %% load 20 secs on each channel and keep them, do an analysis, save results, clear mem, continue
%   segments_sec=20; %we want 20 seconds segments
%   numdatapnts=segments_sec*fs;
%   data20sec=double(data(:,1:numdatapnts));
  
  %% OR make a 3 dimensional array out of it!
nchan=size(data,1);
NN=size(data,2);
num_epochs=floor(NN/4000);
c=4000*num_epochs;
data8n=data(:,1:c);
dataf=reshape(data8n,[nchan 4000 num_epochs]); %data8n : nchan 4000 b
clear c b NN data8
save dataf dataf
%% function analysis 1 correlation coefficient
for k=1:num_epochs
    tempiii=dataf(1:nchan,:,k)'; %% it wants first the data points, then the number of channels
    result1(:,:,k)=corrcoef(tempiii);
    a=squeeze(result1(:,:,k));
%       2-d PLOTS     
%     figure; imagesc(a); set(gca,'Ytick', 1:8); set(gca, 'XTick', 1:8); set(gca, 'YTickLabel', s); set(gca, 'XTickLabel', s);
%     axis xy; axis tight; colorbar('location','EastOutside')
%    clear tempiii a 
 end
clear k 
% Interactions Plots O1-F1
timeVec2=(1:num_epochs).*20/3600;
h=0
 for kl=1:nchan
     for kj=1:nchan
         if (kl~=kj)
             h=h+1
             index_pool{h,:}=[num2str(kj) num2str(kl)]
             a=strcmp(index_pool, [num2str(kl),num2str(kj)])
             onesz=find(a)
             if length(onesz)==0
                 points=squeeze(result1(kl,kj,:)); 
                 figure; plot(timeVec2, points, '*'); 
                 title([name s(kl) '-' s(kj) ' correlation coeff' ]);
                 axis tight;xlabel('time (hrs)')
                 chan1=cell2mat(s(kl)); chan2=cell2mat(s(kj)); 
                 stemp=['correlation-' num2str(chan1)  '-' num2str(chan2)];
                 saveas(gcf, stemp, 'fig'); 
             end
             clear onesz a 
         end
         
     end
 end
 result_cor=result1;
 clear result1
stemp=['correlation-results' ];
eval(['save ' stemp ' result_cor timeVec2 s nchan name num_epochs'])

