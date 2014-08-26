%% Example 1 - Reach-to-Grasp Movements 
% This example will show you how to write a simple script using RTMoCap
% functions using MATLAB(R)
% 
% Copyright (C) 2014 Daniel Lewkowicz <daniel.lewkowicz@gmail.com>
% 
% This program is free software; you can redistribute it and/or modify it
% under the terms of the GNU General Public License as published by the
% Free Software Foundation; either version 3 of the License, or (at your
% option) any later version.
% 
% This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
% Public License for more details.
% 
% You should have received a copy of the GNU General Public License along
% with this program; if not, see <http://www.gnu.org/licenses/>.

%% STEP 1 : Initial Configuration
% Config file
[Fs,duration,nb_trials,delay,nb_markers,sp_threshold,nb_pauses,reward,marker_table] = RTMocap_design();

% Initializing Audio Tones
[high,low,coin,spit,funk] = RTMocap_audioinit();

% Qualisys config file
q=QMC('QMC_conf.txt');

%% STEP 2 : Configuration of Reference Position 
start_ref = RTMocap_pointref('Index','INITIAL',1,200);
stop_ref = RTMocap_pointref('Index','TERMINAL',1,200);

% Initializing Variables % 

% Rebooting the random number generator
rng('shuffle');
% before MATLAB 7.1
% rand('seed',sum(100*clock));

% Error Tables
err_tab_start=zeros(nb_trials,6);
err_tab_end=zeros(nb_trials,6);

% n: Current trial
n=1;

% Delay table
delay_tab=zeros(nb_trials,1);
err_tab=zeros(nb_trials,6);

%%  STEP 3 : Getting ready and Capture   
% Infinite Loop until total number of trials _nb_trials_ is reached
while n_rec <= nb_trials        
disp(['GET READY FOR TRIAL n° ',num2str(n)]);

% from end position to start position
pause(delay/2)

% participant at starting position
disp('-------- SET --------');

% prepare for capture
clear data

% random delay (from delay*1/2 to delay*3/2)
delay_tab(n)=(delay/2+rand*delay);
pause(delay_tab(n));

play(high);
disp('-------- GO --------');

% capture
[data,time] = RTMocap_capture(duration,Fs,nb_markers,n_rec);

%% STEP 4 : Writing data files and data processing

% write the file
file_data=['Raw_data_', num2str(n,'%03d'),'.txt'];
dlmwrite(filewrite,data, '\t');

file_time=['Raw_time_', num2str(n,'%03d'),'.txt'];
dlmwrite(filewrite,time, '\t');

% interpolation
data_i = RTMocap_interp(data,time,Fs);

% if still missing, then restart the same capture
if  sum(sum(sum(isnan(data_i))))
    disp('NaN');
    play(spit);
    continue;
end 

% smoothing with butterworth Fs=200hz Fc=10hz order=4 
data_sm = RTMocap_smooth(data_i,200,10,4);

%% STEP 5 : Threshold verification and Reward

% start position
start_pos=mean(data_sm(1:Fs/4,:,marker_table(1,1)));

if RTMoCap_3Ddist(start_pos,start_ref) > marker_table(1,2)
    RTMoCap_reward(reward,-1);
    disp(RTMoCap_3Ddist(start_pos,start_ref));
    disp('INITIAL POSITION BAD - REJECTED TRIAL');
    continue
end    
    
% stop position
stop_pos=mean(data_sm(end-Fs/10:end,:,marker_table(1,1)));

if RTMoCap_3Ddist(stop_pos,stop_ref) > marker_table(1,2)
	RTMoCap_reward(reward,-1);
	disp(RTMoCap_3Ddist(stop_pos,stop_ref));
	disp('TERMINAL POSITION BAD');
else
    RTMoCap_reward(reward,+1); 
end   
    
err_tab(n,:)=[stop_pos stop_ref];


n=n+1;
% everything is fine, go back for next trial
end

%% STEP 6 : Writing files and stop the session
dlmwrite('err_tab.txt',err_tab, '\t');
dlmwrite('delay_tab.txt',delay_tab, '\t');

RTMoCap_reward(reward,'end');