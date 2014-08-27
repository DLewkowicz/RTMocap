% RTMOCAP_DESIGN Design your experiment with a series of questions
% 
%       RETURNS
%       FS, Capture Frequency 
%       DURATION, Duration of recordings 
%       NB_TRIALS, Number of trials 
%       DELAY, InterTrial Iterval (ITI) 
%       NB_MARKERS, Total number of markers to be captured 
%       SP_THRESHOLD, Initial Speed Threshold 
%       NB_PAUSES, Number of pauses 
%       REWARD, Reward type 1:Artificial 2:Engaging
%       MARKER_TABLE, N-by-3 Matrix: [MARKER_NUM,RADIUS,DURATION]          
%           MARKER_NUM is the marker indice in marker list 
%           RADIUS, radius of the virtual 3-D sphere around the position
%           DURATION, the amount of time to wait at this position (pause)
%           N equal to 1 + NB_PAUSES
%
%       The first line of MARKER_TABLE is the final posititon. 
%       A valid check at this position will consider a trial as 'completed'.
%       The duration of the pause at final position is the mean DELAY (ITI)
%       The next lines are reserved for spatial positions of Pauses.
%         
% Copyright (C) 2014 Daniel Lewkowicz <daniel.lewkowicz@gmail.com>
% RTMocap Toolbox available at : http://sites.google.com/RTMocap/ 
% 
% This program is free software; you can redistribute it and/or modify it
% under the terms of the GNU General Public License as published by the
% Free Software Foundation;
% 
% This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
% Public License for more details.
% 
% You should have received a copy of the GNU General Public License along
% with this program; if not, see <http://www.gnu.org/licenses/>.

% History : 
% version 1.0 - Daniel Lewkowicz - 08-2014

function [Fs,duration,nb_trials,delay,nb_markers,sp_threshold,nb_pauses,reward,marker_table] = RTMocap_design()

% The name of the experiment configuration file
cfg_file=[input('Enter the name of the configuration file: ','s'),'.cfg'];

%% If file already exist, do not ask again
if exist(cfg_file, 'file') == 2

% read the file
config=dlmread(cfg_file);    
    
% parse the variables
Fs=config(1);
duration=config(2);
nb_trials=config(3);
delay=config(4);
nb_markers=config(5);
sp_threshold=config(6);
nb_pauses=config(7);
reward=config(8);

marker_table=zeros(size(nb_pauses+1,3));
   
offset=size(config,1)-(nb_pauses+1)*3;
for i=1:nb_pauses+1
    marker_table(i,1)=config(offset+(i-1)*3+1);
    marker_table(i,2)=config(offset+(i-1)*3+2);
    marker_table(i,3)=config(offset+(i-1)*3+3);
end


else
%% else, ask questions and write a file
nb_pauses=0;
sp_threshold=1000;

% Pause? 
pause=input('0:No Pause, 1:With Pause(s) ');
if isempty(pause);pause=0;end

if pause == 1
    nb_pauses=input('Enter the number of Pause: ');
    if isempty(nb_pauses);nb_pauses=0;end
end

% Reward Type?
reward=input('0:No Reward, 1:Artificial Reward, 2:Engaging Reward ');

if reward==2
    adjust=input('Dynamic Speed Threshold ? 0:No Adjusting, 1:With Adjusting ');
        
    if adjust == 1
        sp_threshold=input('Enter the initial speed threshold (mm.s-1): ');
        if isempty(sp_threshold);sp_threshold=1000;end
    end
end
        
% Total number of markers
nb_markers=input('Enter the total number of markers in marker list: ');    
    
marker_table=zeros(size(nb_pauses+1,3));
if pause == 1
    for i=2:nb_pauses+1
        marker_table(i,1)=input(['Enter the marker position in list associated with the pause n°',num2str(i-1),' ']);
        marker_table(i,2)=input(['Radius of position error (mm) associated with pause n°',num2str(i-1),' ']);
        marker_table(i,3)=input(['Enter the duration of the pause n°',num2str(i-1),' ']);
    end
end    

% The index number of the marker to be 'checked'        
marker_table(1,1)=input('Enter the marker position in list associated with the End of the trial: ');
    
% The accuracy threshold in millimeters
marker_table(1,2)=input('Enter the radius of position error (mm) associated with End of the trial: ');
    
% No pause duration at the end, a random delay between trials is set below
marker_table(1,3)=0;    

% Capture Frequency
Fs = input('Enter the capture frenquency: ');

% Measurement Time (seconds)
duration = input('Enter the measurment time (seconds): ');

% Maximum number of trials, default = 20;
nb_trials=input('Enter the number of trials for this block: ');
if isempty(nb_trials);nb_trials=20; end  

% The duration of the inter-trial pause
delay=input('Enter the mean inter-trial delay (seconds): ');

cfg_tab=[Fs,duration,nb_trials,delay,nb_markers,sp_threshold,nb_pauses,reward]';
offset=size(cfg_tab,1);

for i = 1:size(marker_table,1)
    cfg_tab(offset+(i-1)*3+1)=marker_table(i,1);
    cfg_tab(offset+(i-1)*3+2)=marker_table(i,2);
    cfg_tab(offset+(i-1)*3+3)=marker_table(i,3);
end
    
% write the config file
dlmwrite(cfg_file,cfg_tab);    
    
    
end

 
end