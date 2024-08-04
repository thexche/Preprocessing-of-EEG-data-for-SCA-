% ##### PIPELINE STEP 5 (FASTICA_1) #####

clear; close all; clc;

% Participant IDs
% ID={'P10','P11'}; % ADD MORE ID HERE

% Data path
pathIn ='E:\RAW\pre-treatment_[-5,20]\right\step2';
pathOut = 'E:\RAW\pre-treatment_[-5,20]\right\step4';

%dlist
cd(pathIn)  %cd(pathOut)
dirList= dir('*step2*set');
files={dirList.name};

%% 
for idx =  1 : numel(files)
    
   
    eeglab
    
cd(pathIn)
    % Load the data
   EEG = pop_loadset('filename',files{idx},'filepath',pathIn);
    name = files{idx};
    name(strfind(files{idx},'step2.set'):end)=[];
eeglab redraw
        % Remove the pulse artifact before ica
        EEG = pop_tesa_removedata( EEG, [-5 20] ); 

    % Run FastICA
    EEG = pop_tesa_fastica( EEG, 'approach', 'symm', 'g', 'tanh', 'stabilization', 'off' );
    
    % Component selection after FastICA   !!!!!!!!!!! this step needs a new
    % version of TESA (https://github.com/nigelrogasch/TESA).
    EEG = pop_tesa_compselect( EEG,'compCheck','off','remove','on','saveWeights','off','figSize','small','plotTimeX',[-200 500],'plotFreqX',[1 100],'freqScale','log','tmsMuscle','on','tmsMuscleThresh',4,'tmsMuscleWin',[11 35],'tmsMuscleFeedback','off','blink','on','blinkThresh',2.5,'blinkElecs',{'Fp1','Fp2'},'blinkFeedback','off','move','on','moveThresh',2,'moveElecs',{'F7','F8'},'moveFeedback','off','muscle','on','muscleThresh',-0.31,'muscleFreqIn',[7 70],'muscleFreqEx',[48 52],'muscleFeedback','off','elecNoise','off','elecNoiseThresh',4,'elecNoiseFeedback','off' );

    % Save the data
    EEG = pop_saveset( EEG, 'filename',[name,'step4.set'],'filepath',pathOut);
    cd(pathOut)
end




