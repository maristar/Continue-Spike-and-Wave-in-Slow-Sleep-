%% Data analysis using wavelets
ndata=1;
collect_chans_L=lapldata;
s=channelsc;
nchan=length(s);
fs=512;
timeVec=(1:length(lapldata)).*1/fs;
%% analysis characteristics %%%%
width = input('With starting width     ');
freqN = input('frequency to start?        ');
repeats = input('For how many times -subsequent frequency bands?   ');
tic
%% Define frequencies
    freq1=freqN;
    freqN=freq1+20;  
    step=0.2;
    freqVec =freq1:step:freqN; % 2:0.05:16
    disp(freq1)
    disp(freqN)
    B = zeros(length(freqVec), size(collect_chans_L, 2)); %% freqVec x timeLength
    B(1,:)=0;
%% Analysis core
for q = 1:repeats
for n=1:nchan  %start for every source - channel
    TFR = []; %einai gia na to adeiasei
%             for r=1:size(collect_chans_L, 3)     % for every single trial     
                for j=1:length(freqVec)  %gia kathe frequency
                    a=squeeze(collect_chans_L(n, :));
                      B(j, :) = (energyvec(freqVec(j), a, fs, width)) + B(j,:);
                      clear a
               % end
            end
            %TFR = B/size(collect_chans_L,3);  % To TFR einai o mesos oros toy B, or minus one 3marzo2004
            TFR_array(:,:,n) = B;
    
end   % end for every source
  %TFR_all:  freqVec x timepoints x nchan
   % clear TFR
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
   pathname1='C:\Users\Maria\Desktop\1stdatas';
     filename1='lapl_128';
     len_1 = length(filename1); % filenamex = vipi160
    save_name=[filename1 '_ANALYSIS_'];    
    stemp1 = [save_name '_' num2str(freq1) '_' num2str(freqN) '_' 'step' num2str(step) '_' 'recon_array_width' num2str(width)]; 
    stempext = ('.mat'); 
    stemp2 = [stemp1 stempext]; 
    pathname_save=pathname1;
    cd(pathname_save) %
    mkdir(stemp1); % 
    cd(stemp1); % 
    eval(['save ' stemp2 ' TFR_array freqVec timeVec step filename1 stemp1 s ndata nchan'])
end
toc    