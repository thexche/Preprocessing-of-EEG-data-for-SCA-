% this is to combine the pre and post datasets


clear; close all; clc;

% ID={'P10','P11'}; % ADD MORE ID HERE
ID={'PT_P1', 'PT_P2','PT_P3','PT_P4','PT_P6','PT_P7','PT_P8','PT_P9','PT_P10','PT_P11','PT_P12','PT_P13','PT_P14','PT_P15','PT_P16'};
%  ID ={'PT_P17','PT_P18','PT_P19','PT_P20','PT_P21','PT_P22','PT_P23','PT_P24','PT_P25','PT_P26','PT_P27','PT_P28','PT_P29','PT_P30','PT_P31','PT_P32','PT_P33','PT_P34','PT_P35'};
%  ID = {'PT_P37','PT_P38','PT_P39','PT_P40','PT_P41','PT_P42','PT_P43','PT_P44','PT_P46'};

% Data path
pathIn ='E:\RAW\pre-treatment_[-5,20]\right\step1\step1_dsp';
pathOut = 'E:\RAW\pre-treatment_[-5,20]\right\step3';
cd(pathIn)
%cd(pathOut)
%% run the loop
for idx = 1:length(ID)
   
    eeglab   
cd(pathIn)

 % Load the PRE data
   EEG = pop_loadset('filename',[ID{idx} '_PRE_tep_right_step1_dsp.set'],'filepath',pathIn);

% Loop within the loop, in order to merge pre and post data together
    for b = 1:size(EEG.event,2) % 
        EEG.event(1,b).type = 'PRE'; %<<<<<< 'PRE' OR 'POST' >>>>>>
    end
    
    [ALLEEG, EEG, CURRENTSET]=eeg_store(ALLEEG, EEG, 1); %  1=PRE   or   2=POST



 
    % Load the POST data
   EEG = pop_loadset('filename',[ID{idx} '_POST_tep_right_step1_dsp.set'],'filepath',pathIn);

% Loop within the loop, in order to merge pre and post data together
    for b = 1:size(EEG.event,2) % 
        EEG.event(1,b).type = 'POST'; %<<<<<< 'PRE' OR 'POST' >>>>>>
    end
    
    [ALLEEG, EEG, CURRENTSET]=eeg_store(ALLEEG, EEG, 2); %  1=PRE   or   2=POST


    % Merge Files
sizeTp = 1:1:size(ALLEEG,2); %create number of time points -> 2 time points
EEG = pop_mergeset(ALLEEG, sizeTp, 0); %merge time points

EEG.urevent =[]; %reconstruct urevent -> making sure that information within EEG structure is consistent (event and urevent)
for a = 1:size(EEG.event,2)
    EEG.urevent(1,a).epoch = EEG.event(1,a).epoch;
    EEG.urevent(1,a).type = EEG.event(1,a).type;
    EEG.urevent(1,a).latency = EEG.event(1,a).latency;
end
eeglab redraw
% Save the data
    EEG = pop_saveset( EEG, 'filename',[ID{idx} '_merge_tep_right_step3.set'],'filepath',pathOut);

end