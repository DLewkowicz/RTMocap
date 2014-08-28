% RTMOCAP_POINTREF Set a Reference Point
% 
% This function will help you to set a point as a reference position.
% Typically each trial would have at least a 'starting' position
% and a 'terminal' position that can be checked. You can set both
% individually by using this function
% 
%   Usage : [ref] = RTMocap_pointref(name,name_pos,M,F,cam)
% 
%   NAME: The name of the marker
%   NAME_POS: The name of the reference position 
%   M: The marker ordinal number in marker list
%   F: Capture Frequency
%   CAM: Matlab link for camera system (ex: qualisys)
% 
%   Returns 
%   REF: Reference position as a 1x3 array, [X Y Z]
%
%   Example
%   [ref] = RTMocap_pointref('Index','Initial',4,200) 
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

function [ref] = RTMocap_pointref(name,name_pos,M,F,cam)

% Infinite loop until reference position has been calibrated
while exist('ref','var')==0
    
close all

    % Please verify that this Marker is correctly identified by the Camera system
    disp(['Place the [',name,'] marker on [',name_pos,'] position and Press a key']);
    pause;
    
% Calibration duration : half a second
[data,~]=RTMocap_capture(0.5,F,M,1,cam);
    
% Check if marker was occluded    
if any(isnan(data(:,:,M)))
    answer=input('NaNs in data, Would you like to calibrate this postition again ? y/n ','s');
    if answer == 'y'
        % restart loop
        continue;
    end    
end

% Check if marker has moved
RTMocap_display(data(:,:,M),F);

if any(RTMocap_3Dvel(data(:,:,M),F)>20)    
    answer=input('Movement detected, Would you like to calibrate this postition again ? y/n ','s'); 
    if answer == 'y'
        % restart loop
        continue;
    end
end 

% else compute reference position
ref=mean(data(:,:,M));

end
% everything is ok
disp('No problem detected, Press a key to continue');
pause

close all

end
