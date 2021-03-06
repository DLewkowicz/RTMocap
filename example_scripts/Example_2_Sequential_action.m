%% Example 2 - Sequential actions 
% This example will show you how to use RTMoCap for imposing spatiotemporal
% constraints
% 
% Copyright (C) 2014 Daniel Lewkowicz <daniel.lewkowicz@gmail.com>
% RTMocap Toolbox available at : http://sites.google.com/RTMocap
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

%% STEP 1 : Initial Configuration
clear all
close all

% Config file
[Fs,duration,nb_trials,delay,nb_markers,sp_threshold,nb_pauses,reward,marker_table] = RTMocap_design();

% Initializing filter parameter
Fc=10;
order=4; 

% Initializing Audio Tones
audio = RTMocap_audioinit;

% Qualisys config file
global qualisys
qualisys=QMC('QMC_conf.txt');

%% STEP 2 : Configuration of Reference Position 
start_ref = RTMocap_pointref('Object','INITIAL',marker_table(1,1),Fs,qualisys);
stop_ref = RTMocap_pointref('Object','TERMINAL',marker_table(1,1),Fs,qualisys);

pause_table=zeros(size(marker_table,1)-1,3);
% Reference pause positions
for p=1:size(marker_table,1)-1
    pause_table(p,:) = RTMocap_pauseref('Thumb',p,marker_table(p+1,1),Fs,qualisys);
end

% Initializing Variables % 

% Rebooting the random number generator - comment useless lines (CTRL-R)
% rng('shuffle');	
% before MATLAB 8.0 - uncomment next line (CTRL-T)
s = RandStream('swb2712','Seed',0);
% before MATLAB 7.7 - uncomment next line (CTRL-T)
% rand('seed',sum(100*clock));

% Error Tables
err_tab_start=zeros(nb_trials,6);
err_tab_end=zeros(nb_trials,6);

% n_rec: Current trial
n_rec=1;

% Delay table
delay_tab=zeros(nb_trials,1);
err_tab=zeros(nb_trials,6);

%%  STEP 3 : Getting ready and Capture   
% Infinite Loop until total number of trials _nb_trials_ is reached
while n_rec <= nb_trials        
disp(['GET READY FOR TRIAL n� ',num2str(n_rec)]);

% from end position to start position
pause(delay/2)

% participant at starting position
disp('-------- SET --------');

% prepare for capture
clear data

% random delay (from delay*1/2 to delay*3/2)
delay_tab(n_rec)=(delay/2+rand*delay);
pause(delay_tab(n_rec));

play(audio(1,1).internalObj);
disp('-------- GO --------');

% capture - WITH PAUSES
[data,time] = RTMocap_capturep(duration,Fs,nb_markers,n_rec,qualisys,marker_table,pause_table);

%% STEP 4 : Writing data files and data processing

% write the file
file_data=['Raw_data_', num2str(n_rec,'%03d'),'.txt'];
dlmwrite(file_data,data,'delimiter','\t','precision','%5.3f');

file_time=['Raw_time_', num2str(n_rec,'%03d'),'.txt'];
dlmwrite(file_time,time,'delimiter','\t','precision','%09d');

% interpolation
data_i = RTMocap_interp(data,time,Fs);

% if still missing, then restart the same capture
if  sum(sum(sum(isnan(data_i))))
    disp('NaN');
    play(spit);
    continue;
end 

% smoothing with butterworth Fs=200hz Fc=10hz order=4 
data_sm = RTMocap_smooth(data_i,Fs,Fc,order);

%% STEP 5 : Threshold verification and Reward
close all

% start position
start_pos=mean(data_sm(1:Fs/4,:,marker_table(1,1)));
start_error=RTMocap_3Ddist(start_pos,start_ref);

if  start_error > marker_table(1,2)
    RTMocap_reward(reward,-1,audio);
	RTMocap_display(data_sm,Fs);
    disp(['Distance from start: ',num2str(start_error),' mm']);
    disp('INITIAL POSITION BAD - REJECTED TRIAL');
    continue;
end    
    
% stop position
stop_pos=mean(data_sm(end-Fs/10:end,:,marker_table(1,1)));
accuracy=RTMocap_3Ddist(stop_pos,stop_ref);

if  accuracy > marker_table(1,2)
	RTMocap_reward(reward,-1,audio);
    RTMocap_display(data_sm,Fs);
	disp(['Distance to target: ',num2str(accuracy),' mm']);
	disp('TERMINAL POSITION BAD');
else
    RTMocap_reward(reward,+1,audio);
    RTMocap_display(data_sm,Fs);
    disp(['Distance to target: ',num2str(accuracy),' mm']);
    disp('TERMINAL POSITION GOOD');
end   
    
err_tab(n_rec,:)=[stop_pos stop_ref];

n_rec=n_rec+1;
% everything is fine, go back for next trial

end

%% STEP 6 : Writing files and stop the session
dlmwrite('err_tab.txt',err_tab,'delimiter','\t','precision','%5.3f');
dlmwrite('delay_tab.txt',delay_tab,'delimiter','\t','precision','%2.3f');

RTMocap_reward(reward,0,audio);