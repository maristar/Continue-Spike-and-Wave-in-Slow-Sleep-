% Oslo 2010
% we need the dataset in format chan x datapoints and the names of the
% electrodes in the correct order in .mat

%% select the dataset to work on
clear all 
close all 
[filename, pathname] = uigetfile('*.mat', 'Pick a MATLAB data file');
    if isequal(filename,0) || isequal(pathname,0)
       disp('User pressed cancel')
    else
       disp(['User selected ', fullfile(pathname, filename)])
    end
  % > out filename pathname
adata=load(filename);
data=adata.(filename(1:end-4)); % chan x time
data=double(data); % from eeglab it exits as single, so we have to double it.
fs=input('Sampling frequency? ')
  
% keep in the same directory if not
street=pwd; if ~strcmp(street, pathname(1:end-1)), cd(pathname), end
  
 % clear memory
clear adata clear pathname street fs

% load the matlab .mat file with the names of the electrodes
[filename2, pathname2] = uigetfile('*.mat', 'Pick the cell array with electrode namels file');
    if isequal(filename2,0) || isequal(pathname2,0)
       disp('User pressed cancel')
    else
       disp(['User selected ', fullfile(pathname2, filename2)])
    end
achan=load(filename2);
chan=achan.(filename2(1:end-6))
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
    result1(:,:,k)=partialcorr(tempiii);
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
                     points=squeeze(result1(kl,kj,:)); figure; plot(timeVec2, points, '*'); title([s(kl) '-' s(kj) 'partial-correlation' ]);axis tight;xlabel('time (hrs)'); YLim([-1 1]);
                     stemp=['partial-correlation-' num2str(kl)  '-' num2str(kj)]; saveas(gcf, stemp, 'fig')
             end
             clear onesz a 
         end
         
     end
end
 

