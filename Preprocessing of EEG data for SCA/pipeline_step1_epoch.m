% ##### PIPELINE STEP 1 #####

clear; close all; clc;

% File path where data is stored
pathIn  = 'E:\RAW\pre-treatment_[-5,20]\right\step3'; 
pathOut = 'E:\RAW\pre-treatment_[-5,20]\right\step1\step1_uc';
% caploc
caploc='D:\matlab\toolbox\eeglab13_6_5b\eeglab13_6_5b\plugins\dipfit2.3\standard_BESA\standard-10-5-cap385.elp';

% dlist
cd(pathIn) 
% cd(pathOut)
% dirList= dir('*.vhdr');
dirList=dir('*.set');
files={dirList.name};
elec = 'Oz'; 
%% EEGLAB

for kk=51:numel(files)
    % open eeglab first
    eeglab
cd(pathIn)
    % load data
%EEG = pop_loadbv(pathIn,files{kk} );---BP(hangshida）
%EEG = pop_fileio(files{kk});
EEG = pop_loadbv(pathIn,files{kk} );

[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'gui','off'); 
eeglab redraw  %-Use EEGLAB to open the data
name = files{kk};
shortname=name(1:20); % this is to keep the first 2 letters of the name
shortname=['PT_'  shortname];
name(strfind(files{kk},'.vhdr'):end)=[];
EEG = eeg_checkset( EEG );
EEG = pop_editset(EEG, 'setname', shortname);

[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);

    % Load channel locations
EEG = pop_chanedit(EEG, 'lookup', caploc);
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET); 
    
% Remove unused channels
    EEG = pop_select( EEG,'nochannel',{'IO','FT10','TP10','FT9','TP9'});

% Save the original EEG locations for use in interpolation later
    EEG.allchan = EEG.chanlocs;   
% %find and  remove the peak----find single pluse signal---no mark
%  EEG = tesa_findpulsepeak( EEG, elec, 'dtrnd', 'poly', 'thrshtype','dynamic', 'wpeaks', 'gui', 'plots', 'off', 'tmsLabel', '1');
%  EEG = tesa_findpulsepeak( EEG, elec, 'dtrnd', 'linear', 'thrshtype',500, 'wpeaks', 'gui', 'plots', 'off', 'tmsLabel', '1');
% 
% [EEG,nanspan] = tesa_artwidth(EEG,-10,35);% throw the peak noise , <40
% [EEG,nanspan] = tesa_artcheck(EEG,nanspan,50);
% [~,section]= tesa_artwindow(EEG,nanspan);
% [EEG]= tesa_removeandinterpolate(EEG,nanspan,section,1,4,1, elec ,1); % should be plotting FZ (#6)
% close all

%Epoch around TMS pulse
   EEG = pop_epoch( EEG, { 'S  1' } , [-1  1], 'newname', 'ep', 'epochinfo', 'yes');  %---auto → 'S  1'

   % Remove baseline
    EEG = pop_rmbase( EEG, [-500  -10]);
% Remove the pluse artifact
   EEG = pop_tesa_removedata( EEG, [-5 20] ); % switched from step2
%    EEG = pop_tesa_removedata( EEG, [-10 35] ); % switched from step2
   % save data
    EEG = pop_saveset( EEG, 'filename',[shortname,'_step1.set'],'filepath',pathOut);%---√  
end
return


%% epoch and Remove baseline
clear; close all; clc;

% File path where data is stored
pathIn ='E:\RAW\pre-treatment_[-5,20]\right\step1\step1_uc';
pathOut = 'E:\RAW\pre-treatment_[-5,20]\right\step1\step1_ep';
cd(pathIn) %cd(pathOut)
dirList= dir('*.set');
files={dirList.name};

% run the loop
for idx = 25:numel(files)
    
eeglab
cd(pathIn)
    % Load the data
    EEG = pop_loadset(files{idx});
    
    name = files{idx};
    name(strfind(files{idx},'.set'):end)=[];
    name = [name '_ep'];

% Epoch around TMS pulse
%  EEG = pop_epoch( EEG, { 'S  1' } , [-1  1], 'newname', 'ep', 'epochinfo', 'yes');  %---auto → 'S  1'
 EEG = pop_epoch( EEG, { '1' } , [-1  1], 'newname', 'ep', 'epochinfo', 'yes');
% eeglab redraw
    % Remove baseline
    EEG = pop_rmbase( EEG, [-500  -10]);

    % Save the data
    EEG = pop_saveset( EEG, 'filename',name,'filepath',pathOut);
   
    clear name 
end



%% filter-this is good for very noisy studies----In theory, this step should not be done unless the signal quality is particularly poor
%clear; close all; clc;

% File path where data is stored
%pathIn ='/Volumes/Seagate4T/HUANGMANLI/EEGDATA/EEGCLASS/';
%pathOut = p'/Volumes/Seagate4T/HUANGMANLI/EEGDATA/EEGCLASS/';
%cd(pathIn)
%dirList= dir('*_ep.set');
%files={dirList.name};

% run the loop
%for idx = 1:numel(files)
    
%cd(pathIn)
    % Load the data
  % EEG = pop_loadset(files{idx});
    
   % name = files{idx};
    %name(strfind(files{idx},'_ep.set'):end)=[];
    %name = [name '_filter'];

%EEG = tesa_filtbutter( EEG, 1, 100, 4, 'bandpass' );
%EEG = tesa_filtbutter( EEG, 48, 52, 4, 'bandstop' );% 50 Hz
    
% Save the data
    %EEG = pop_saveset( EEG, 'filename',name,'filepath',pathOut);
    %clear name 
end

%% Remove, Interpolate, and Downsample

clear; close all; clc;

% File path where data is stored
pathIn =  'E:\RAW\pre-treatment_[-5,20]\right\step1\step1_ep';
pathOut = 'E:\RAW\pre-treatment_[-5,20]\right\step1\step1_dsp';
cd(pathIn)%cd(pathOut)
dirList= dir('*_ep.set');
files={dirList.name};

% run the loop
for idx = 1:numel(files)
    
eeglab
cd(pathIn)
    % Load the data
    EEG = pop_loadset(files{idx});
    
    name = files{idx};
    name(strfind(files{idx},'_ep.set'):end)=[];
    name = [name '_dsp'];

        % Remove the pulse artifact
        EEG = pop_tesa_removedata( EEG, [-5 20] ); 

        % Interpolate the missing data
        EEG = pop_tesa_interpdata( EEG, 'cubic', [35 35] );  

        % Downsample to 1000 Hz
        EEG = pop_resample( EEG, 1000);
        eeglab redraw
% Save the data
    EEG = pop_saveset( EEG, 'filename',name,'filepath',pathOut);
    clear name 
end