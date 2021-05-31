%% EEGLAB to econnectome
data=EEG.data(:,1:2000);
name=EEG.setname;
a=size(data);
fs=EEG.srate;



EEG2.data=data;
EEG2.name=EEG.setname;
EEG2.type='EEG';
EEG2.nbchan=a(1);
EEG2.points=a(2);
EEG2.srate=EEG.srate;
EEG2.labeltype='standard' % 'customized'
%for k=1:a(1), B{k}=EEG.chanlocs(k,1).labels, end

%for l=1:(EEG.nbchan), B{l}=B{l}(5:6),end
EEG2.labels=B';
for i=1:length(B), EEG2.locations(i).x=XYZ(i,1), EEG2.locations(i).y=XYZ(i,2), EEG2.locations(i).z=XYZ(i,3), end

% Nz	0,0913	0,0000	-0,0407
% T9	0,0000	-0,0865	-0,0500
% T10	0,0000	0,0865	-0,0500
