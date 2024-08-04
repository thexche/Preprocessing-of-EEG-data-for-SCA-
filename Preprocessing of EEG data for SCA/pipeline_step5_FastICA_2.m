% ##### PIPELINE STEP 6 #####

clear; close all; clc;

% Participant IDs
% ID={'P10','P11'}; % ADD MORE ID HERE

% Data path
pathIn ='E:\RAW\pre-treatment_[-5,20]\right\step4';
pathOut = 'E:\RAW\pre-treatment_[-5,20]\right\step5\PRE';

%dlist
cd(pathIn)%cd(pathOut)
dirList= dir('*step4*set');
files={dirList.name};

%% 
    for idx= 19 : numel(files)
        
 eeglab
    
cd(pathIn)
    % Load the data
   EEG = pop_loadset('filename',files{idx},'filepath',pathIn);
    name = files{idx};
    name(strfind(files{idx},'step4.set'):end)=[];

        % Reduce epoch width to match FrecheModel
%         if strcmp(condition{cx},'FastICA') || strcmp(condition{cx},'SOUND')
%             EEG = pop_epoch( EEG, {  }, [-0.5 0.5], 'newname', 'Merged datasets epochs', 'epochinfo', 'yes');
%         end
%         
        % Remove the pulse artifact
        EEG = pop_tesa_removedata( EEG, [-5 20] ); 

        % Interpolate the missing data
        EEG = pop_tesa_interpdata( EEG, 'cubic', [35 35] );  

% filter-I replaced them with older versions

EEG = tesa_filtbutter( EEG, 1, 100, 4, 'bandpass' );
EEG = tesa_filtbutter( EEG, 48, 52, 4, 'bandstop' );% 50 Hz


        % Remove pulse data
        EEG = pop_tesa_removedata( EEG, [-5 20] );
        
        % Run FastICA
        EEG = pop_tesa_fastica( EEG, 'approach', 'symm', 'g', 'tanh', 'stabilization', 'off' );
        eeglab redraw
        % Remove blinks, lateral eye movements and muscle activity based on
        % heuristics
        EEG = pop_tesa_compselect( EEG,'compCheck','off','remove','on','saveWeights','off','figSize','medium','plotTimeX',[-200 499],'plotFreqX',[1 100],'freqScale','log','tmsMuscle','off','tmsMuscleThresh',8,'tmsMuscleWin',[11 30],'tmsMuscleFeedback','off','blink','on','blinkThresh',2.5,'blinkElecs',{'Fp1','Fp2'},'blinkFeedback','off','move','on','moveThresh',2,'moveElecs',{'F7','F8'},'moveFeedback','off','muscle','on','muscleThresh',-0.31,'muscleFreqIn',[7 70],'muscleFreqEx',[48 52],'muscleFeedback','off','elecNoise','on','elecNoiseThresh',4,'elecNoiseFeedback','off' );
                
        
        
        % Interpolate the missing data
        EEG = pop_tesa_interpdata( EEG, 'cubic', [35 35] );  

    % Interpolate missing electrodes
    EEG = pop_interp(EEG, EEG.allchan, 'spherical');
eeglab redraw
        % Rereference to average
    EEG = pop_reref( EEG, []);

    % Save the data
    EEG = pop_saveset( EEG, 'filename',[name,'step5.set'],'filepath',pathOut);

    % move this line to Line 91 if split data
   

% % SPLIT INTO SEPERATE FILES
pre=[]; post=[];
temp = EEG;
ALLEEG =[]; EEG =[]; CURRENTSET =[];

EEG = temp;eeglab redraw 
EEG = pop_selectevent( EEG, 'type',{'PRE'},'deleteevents','on','deleteepochs','on','invertepochs','off');
EEG = pop_saveset(EEG, 'filename', [name 'final_PRE.set'],'filepath',pathOut);

eeglab redraw
pre = EEG;
        
% EEG = temp;eeglab redraw
% EEG = pop_selectevent( EEG, 'type',{'POST'},'deleteevents','on','deleteepochs','on','invertepochs','off');
% EEG = pop_saveset(EEG, 'filename', [name 'final_POST.set'],'filepath',pathOut);
% eeglab redraw
% post = EEG;
%   
end 
