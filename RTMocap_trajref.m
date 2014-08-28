% RTMOCAP_TRAJREF Set a Reference Trajectory
% 
% This function will help you to set a point as a reference position.
% Typically each trial would have at least a 'starting' position
% and a 'terminal' position that can be checked. You can set both
% individually by using this function
% 
%   Usage : [ref] = RTMocap_trajref(name,duration,M,F,cam)
% 
%   NAME: The name of the marker
%   DURATION: Maximum duration for reference trajectory in seconds
%   M: The marker ordinal number in marker list
%   F: Sampling Frequency
%   CAM: Matlab link for camera system (ex: qualisys)
% 
%   Returns 
%   REF: Reference position as a Nx3 array, [X Y Z] with N equal to
%       DURATION*F
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

function [ref] = RTMocap_trajref(name,duration,M,F,cam)

close all;

[ref_start] = RTMocap_pointref(name,'INITIAL',M,F,cam);
[ref_stop] = RTMocap_pointref(name,'TERMINAL',M,F,cam);

% Infinite loop until reference position has been calibrated
while exist('ref','var')==0

    % Please verify that this Marker is correctly identified by the Camera system
    disp(['TRAJECTORY: Place the [',name,'] marker on the INITIAL position and Press a key']);
    pause;
    
pause(0.5);    
play(high);

% Calibration duration : input variable
[data,~]=RTMocap_capture(duration,F,M,1,cam);
    
% Check if marker was occluded    
if any(isnan(data))
    answer=input('NaNs in data, Would you like to calibrate this TRAJECTORY again ? y/n ','s');
    if answer == 'y'
        % restart loop
        continue;
    end    
end

% Check if marker start is correct
if any(RTMoCap_3Ddist(data(1:F/10,:,M),ref_start))>10
    RTMocap_reward(1,-1);
    answer=input('START POSITION BAD, Would you like to calibrate this TRAJECTORY again ? y/n ','s'); 
    if answer == 'y'
        % restart loop
        continue;
    end
end

if any(RTMoCap_3Ddist(data(end-F/10:end,:,M),ref_stop))>10
    RTMocap_reward(1,-1);
    answer=input('STOP POSITION BAD, Would you like to calibrate this TRAJECTORY again ? y/n ','s'); 
    if answer == 'y'
        % restart loop
        continue;
    end    
end

vel=RTMocap_3Dvel(data(:,:,M),F);
plot(vel);
figure;
plot3(data(:,1,M),data(:,2,M),data(:,3,M));
axis square;

% else compute reference position
RTMocap_reward(1,+1);
ref=data(:,:,M);  

end

end
