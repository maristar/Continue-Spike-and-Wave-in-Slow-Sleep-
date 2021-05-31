% * All TFRS for all datasets*
%% CONNECTIVITY matrices calculation %%%
%%28 Oct 2009
%% START by clearing
% clear all
%% IMIA 
%% the startup function
Fs = 2500;
t  = 0:1/Fs:1-(1/Fs);
A  = 1;   % Vpeak
F1 = 20; % Hz
x  = A*sin(2*pi.*t*F1);
noise=randn(1, length(t));
x=0.1*x+noise; 

idx = 1:128;
figure; subplot(2,1,1);
plot(t(idx),x(idx)); grid; ylabel('Amplitude'); xlabel('Time (sec)');
axis tight;
h = spectrum.periodogram('hamming');
hopts = psdopts(h,x);  % Default options
set(hopts,'Fs',Fs,'SpectrumType','onesided','centerdc',true);
subplot(2,1,2);msspectrum(h,x,hopts);
set(gcf,'Color',[1 1 1])
%end of the start up function
x_del=0.1*cos(2*pi*t*F1)+noise; 

%x_del=A*sin(2*pi*(t+(20*1/Fs))*F1);
figure(100); plot(x); hold on; plot(x_del, 'r')

disp('START..>>>')
fs=input('Write the Sampling Frequency Fs ..');
dt = 1/Fs; 

ndata = 1;% input('How many datasets?     ');
nsorgenti= 2;%%%input('numero sorgenti?       ');
nchan = nsorgenti;
tic
timeVec=t;
timeVec_msec=1000.*t;

freqN = input('frequency to start?        ')
% Frequency Info
repeats = 1;% input('For how many times -subsequent frequency bands?   ')
for q = 1:repeats
    freq1=freqN;
    freqN=freq1+4;  
    freqVec =freq1:0.1:freqN; % 2:0.05:16  %% To eida kai 0.25 
    width = 16;
    disp('Calculating for Hz')
    n_freq=length(freqVec);
    disp(freq1)
    disp(freqN)
    load x
    load x_del
    ntri=1;  
    TFR_array = zeros(length(freqVec), length(timeVec), nchan);
    ii=sqrt(-1); % laura
    collect_sts_all=zeros(nchan, length(timeVec)); 
    collect_sts = zeros(nchan, length(timeVec)); 
    collect_sts(1, :) = x;   
    collect_sts(2, :) = x_del; 
%     collect_sts = collect_sts'; % Ara collect_sts = nchan x timepoints
    B=zeros(length(freqVec), length(timeVec));
    PH=zeros(length(freqVec), length(timeVec));
    tempPH = zeros(nchan, length(freqVec), length(timeVec)); %laura
    
    TFR = []; %einai gia na to adeiase
            for r=1:2 % the channels
                for j=1:length(freqVec)  %gia kathe frequency
                    [enrg,ph] = energyvec_phase(freqVec(j), collect_sts(r, :), fs, width);%
                      B(j, :) =enrg + B(j,:); %energyvec_phase(freqVec(j), collect_sts(r, :), fs, width) + B(j,:);
                      PH(j, :) = ph; %energyvec_phase(freqVec(j), collect_sts(r, :), fs, width) + B(j,:);
                end
                tempPH(r, :, :) = PH(:,:); 
            end
end   % end for every source / channel 

        %TFR_all: nchan x freqVec x timepoints 
       
     %Exw dialexei mia syxnotita !!! tin noumeero 3
     
        %for l = 1:(ntri-2) % Gia kathe single trial ftiaxnoume ena array me ta single trials, to collect_sts
        
                            figure;
                            a1=squeeze((tempPH(1,21,:)));
                            subplot(5,1,2);plot(timeVec_msec,a1);axis tight;
                            title(['Phase of Ch ' num2str(1)])
                            
                            subplot(5,1,1);plot(timeVec_msec,x);axis tight;
                            title('Ch 1')
                            
                            a2=squeeze((tempPH(2,21,:)));
                            subplot(5,1,4); plot(timeVec_msec,a2);axis tight;
                            title(['Phase of Ch ' num2str(2)]);
                            
                            subplot(5,1,3);plot(timeVec_msec,x_del);axis tight;
                            title(['Ch ' num2str(2)]);
                            
                            subplot(5,1,5);
                            a13=abs(squeeze(unwrap(tempPH(1,21,:)-tempPH(2,3,:))));
                            plot(timeVec_msec,a13);axis tight;
                            title(['Phase Difference between Ch ' num2str(1) '-Ch' num2str(2) ' At fq=' num2str(freqVec(3))]);
                            %collect_phs(:,k1,k2)=a13;  %% ntris x stdatapoints x nchan1 x nchan2 
                            
                            
%                             [ax,h5]=suplabel(['Single Trial'] ,'t');  
%                             set(h5,'FontSize',11) 
                                   
                 
                  
    avg_phs=mean(collect_phs,3); %%avg_phs=ntris x datapoints x nchan1 
    avg_phs_final=mean(avg_phs,1); %%% 1 x datapoints x nchan
    figure; subplot(3,1,1);plot(timeVec_msec, avg_phs_final(:,:,1)); title(['Average Phase Difference of Channel ' num2str(1) ' averaged contribution to all other channels']);
    subplot(3,1,2);plot(timeVec_msec, avg_phs_final(:,:,2)); title(['Average Phase Difference of Channel ' num2str(2) ' averaged contribution to all other channels']);
    subplot(3,1,3);plot(timeVec_msec, avg_phs_final(:,:,3)); title(['Average Phase Difference of Channel ' num2str(3) ' averaged contribution to all other channels']);
     
        %%%% we average the single trials phase information into one
        %%%% average
        
avg_phs_f=mean(collect_phs,1); %% 1 x datapoints x nchan x nchan
figure; plot(timeVec_msec, avg_phs_f(1,:,1,2)); title(['Ch ' num2str(1) '-Ch' num2str(2) ' fq=' num2str(freqVec(3))]);%% ch 1 - ch 2
figure; plot(timeVec_msec, avg_phs_f(1,:,1,3)); title(['Ch ' num2str(1) '-Ch' num2str(3) ' fq=' num2str(freqVec(3))]);%% ch 1 - ch 3
figure; plot(timeVec_msec, avg_phs_f(1,:,2,3));title(['Ch ' num2str(2) '-Ch' num2str(3) ' fq=' num2str(freqVec(3))]);%% ch 2 - ch 3
          
 %%(number of repetitions - datas)

       
