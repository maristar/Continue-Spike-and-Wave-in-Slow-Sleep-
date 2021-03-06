%% Data analysis using wavelets
clear all 
close all 

%% Load data 
ndata=1;
[filename, pathname] = uigetfile('*.mat', 'Select a MATLAB file');
if isequal(filename,0)
   disp('User selected Cancel')
else
   disp(['User selected', fullfile(pathname, filename)])
end
collect_chans_L1=load(filename);
collect_chans_L=collect_chans_L1.(filename(1:end-4));
clear collect_chans_L1 data10
% collect_chans_L einai ncnan x length1single trial x number of single
% trials
%% Load channel info -names and location 
[filename2, pathname2] = uigetfile('*.mat', 'Select the channel MATLAB file');
if isequal(filename2,0)
   disp('User selected Cancel')
else
   disp(['User selected', fullfile(pathname2, filename2)])
end
s1=load(filename2);
s=s1.(filename2(1:end-6));
clear s1 filename2 pathname2
% Now we have an s file which is a 1x10 cell with the names of the
% electrodes
%% More useful stuff
nchan=length(s);
fs=200;
N=size(collect_chans_L,2);
timeVec=(1:N).*1/fs;
clear N 
%% analysis characteristics %%%%
width = input('With starting width     ');
freqN = input('frequency to start?        ');
repeats = input('For how many times -subsequent frequency bands?   ');
tic
% epoch_step=30; %% this forms 10 minutes interval 
% times=floor(3858/(3*10*6)); % 21
% for kk=1:times, hrs(kk)=((kk-1)*200)+1, end

%% Define frequencies
for q = 1:repeats
    freq1=freqN;
    freqN=freq1+20;  
    step=0.2;
    freqVec =freq1:step:freqN; % 2:0.05:16
    disp(freq1)
    disp(freqN)
    B = zeros(length(freqVec), size(collect_chans_L, 2)); %% freqVec x timeLength
    B(1,:)=0;
%% Analysis core
for n=1:nchan  %start for every source - channel
    TFR = []; %einai gia na to adeiasei
     B = zeros(length(freqVec), size(collect_chans_L, 2)+1201); 
     for r=2:30+1%%%%size(collect_chans_L, 3)     % for every single trial     
         for j=1:length(freqVec)  %gia kathe frequency
             a=squeeze(collect_chans_L(n, :, r));
             a_before=squeeze(collect_chans_L(n, :, r-1));
             a_after=squeeze(collect_chans_L(n, :, r+1));
             a=[a_before(end-600:end) a  a_after(1:600)];
             B(j, :) = (energyvec(freqVec(j), a, fs, width)) + B(j,:);
             clear a
         end
         %B_epoch(j,:,:,r)=B;
     end
     TFR = B/size(collect_chans_L,3);  % To TFR einai o mesos oros toy B, or minus one 3marzo2004
     TFR_array(:,:,n) = TFR;
end   % end for every source
  %TFR_all:  freqVec x timepoints x nchan
  clear TFR n r j 
   
 % In case we need to average from multiple datasets, if our original
 % dataset was divided in many parts
%    x_array=zeros(ndata, length(timeVec));
%     recon_array = zeros(length(freqVec), length(timeVec), nchan);
%     for d = 1:nchan
%         for f = 1:(length(freqVec))
%             x_array = TFR_array(f,:,d); %% pick a frequency, for all the single trials
%             mx_array = mean(x_array, 1); %% average all the single trials for that frequency
%             recon_array(f,:,d) = mx_array;
%         end
%     end
%     x_array=zeros(ndata, length(timeVec));
%     recon_array = zeros(length(freqVec), length(timeVec), nchan);
%     for d = 1:nchan
%         for f = 1:(length(freqVec))
%             x_array = TFR_array(f,:,d);
%             mx_array = mean(x_array, 1);
%             recon_array(f,:,d) = mx_array;
%         end
%     end
    
     % % Forming the general name of the dataset 
  
%%
    len_1 = length(filename); % filenamex = vipi160
    save_name=[filename(1:end-4) '_ANALYSIS_'];    
    stemp1 = [save_name '_' num2str(freq1) '_' num2str(freqN) '_Hz_step' num2str(step) '_width_' num2str(width)]; 
    stempext = ('.mat'); 
    stemp2 = [stemp1 stempext]; 
    pathname_save=pathname;
    cd(pathname_save) %
    mkdir(stemp1); % 
    cd(stemp1); % 
    eval(['save ' stemp2 ' TFR_array freqVec timeVec filename stemp1 s step width freq1 freqN ndata nchan'])
end
toc/3600,  disp('hours')