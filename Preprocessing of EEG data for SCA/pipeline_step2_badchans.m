%%  Manually check bad channels and epochs, this is much faster than the 'file' methods
eeglab
% check bad channels
EEG = pop_select(EEG,'nochannel',{'f1','oz'});
eeglab redraw
clear;clc



% <<<<<<<<<<<<<<<< then manually check bad epochs >>>>>>>>>>>>>>>>>>>>>>>>



% when you finish these two steps, save the data. Do not
% replace the 'step1' file as you may need to come back to check them.