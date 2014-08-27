% RTMOCAP_TRAJREF Set a Reference Trajectory
% 
% This function will help you to set a point as a reference position.
% Typically each trial would have at least a 'starting' position
% and a 'terminal' position that can be checked. You can set both
% individually by using this function
% 
%   Usage : [ref] = RTMocap_trajref(name,duration,num,Fs)
% 
%   NAME: The name of the marker
%   DURATION: Maximum duration for reference trajectory in seconds
%   NUM: The marker ordinal number in marker list
%   FS: Sampling Frequency
% 
%   Returns 
%   REF: Reference position as a Nx3 array, [X Y Z] with N equal to
%   DURATION*FS
%
%   Example
%   [ref] = RTMocap_trajref('Index',4,200,2) 
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

function [ref] = RTMocap_trajref(name,duration,num,Fs)

% Qualisys config file
if ~exist('q','var')
    q=QMC('QMC_conf.txt');
end

close all;

[ref_start] = RTMocap_pointref(name,'INITIAL',num,Fs);
[ref_stop] = RTMocap_pointref(name,'TERMINAL',num,Fs);

nb_samples=duration*Fs;
% Infinite loop until reference position has been calibrated
while exist('ref','var')==0

    disp(['TRAJECTORY: Place the [',name,'] marker on the INITIAL position and Press a key']);
    pause;
    
pause(0.5);    
play(high);

% Calibration duration : input variable
    m=zeros(nb_samples,3);
    for i=1:nb_samples
        disp('Calibration...');
        [labels,~]=QMC(q);
        m(i,:)=labels(:,num)';
    end
    
% Check if marker was occluded    
if any(isnan(m))
    answer=input('NaNs in data, Would you like to calibrate this TRAJECTORY again ? y/n ','s');
    if answer == 'y'
        % restart loop
        continue;
    end    
end

% Check if marker start is correct
if any(RTMoCap_3Ddist(m(1:Fs/10,:),ref_start))>10
    RTMocap_reward(1,-1);
    answer=input('START POSITION BAD, Would you like to calibrate this TRAJECTORY again ? y/n ','s'); 
    if answer == 'y'
        % restart loop
        continue;
    end
end

if any(RTMoCap_3Ddist(m(end-Fs/10:end,:),ref_stop))>10
    RTMocap_reward(1,-1);
    answer=input('STOP POSITION BAD, Would you like to calibrate this TRAJECTORY again ? y/n ','s'); 
    if answer == 'y'
        % restart loop
        continue;
    end    
end

plot(RTMoCap_3Dvel(m,Fs));
figure;
plot3(m(:,1),m(:,2),m(:,3));
axis square;

% else compute reference position
RTMocap_reward(1,+1);
ref=m;  

end

end
