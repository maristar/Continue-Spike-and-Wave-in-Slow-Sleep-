ndata=1;
load s
nchan=length(s);

%% analysis characteristics %%%%
width = input('With starting width     ');
freqN = input('frequency to start?        ');
repeats = input('For how many times -subsequent frequency bands?   ');
tic
%% Define frequencies
freq1=freqN;
freqN=freq1+40;  
step=0.5;
freqVec =freq1:step:freqN; % 2:0.05:16
disp(freq1)
disp(freqN)

%% epoching instead

[filename2, pathname2] = uigetfile('*.mat', 'Select the data file (*.mat) ');
if isequal(filename2,0)
   disp('User selected Cancel')
else
   disp(['User selected', fullfile(pathname2, filename2)])
end;
data=load(filename2)
fulname=[pathname2 filename2];
name=filename2(1:end-4)

data1=getfield(data, name);
data2=squeeze(data1);
clear data1 data
data=data2; % timepoints x num_epochs
clear data2

epoch_length=size(data, 1);
num_epochs=size(data, 2);
timeVec=(1:epoch_length).*1/fs;
Bwav = zeros(length(freqVec), epoch_length); %% freqVec x timeLength
Bwav(1,:)=0;
%% start!!!
 %size(data10,2)
    for kk=1:num_epochs
        temp=squeeze(data(:, kk));
        mean_temp=(temp-mean(temp))/std(temp);
        %wavelet here!!!
        for ff=1:length(freqVec)
            a=(energyvec(freqVec(ff), mean_temp, fs, width))'; 
            Bwav(ff,:)=a;
            clear a
        end
        Bw_all(:,:,kk)=Bwav;
        clear temp mean_temp event_dp kk Bwav
    end
% epocheddata10 1501 x 399 x 10  (length epoch x num epochs x nchan)
clear jjk
nchan=1


% avewraging the wavelets per channel

averagechan_wav=mean(Bw_all, 3);
    

% plotting the wavelets
    figure; 
    h=imagesc(timeVec, freqVec, averagechan_wav); axis xy; title(name);xlabel('time (ms)'); ylabel('frequency (Hz)')
    temp_image=['Averaged wavelet channel ' s{kkj}]
    saveas(h, temp_image, 'fig')
    clear temp

    
results.panos.waveletsall=Bw_all;
results.panos.averagechan_wav=averagechan_wav;
save results results
save results results -v7.3

