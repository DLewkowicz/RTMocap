% RTMOCAP_DISPLAY Plots the velocity profile
% 
%  This function will help you to compute the first moment in time when 
%   a specific velocity threshold has been reached 
% 
%   Usage : time_event = RTMoCap_display(A,threshold,F)
% 
%   A, a N-by-3 array of recorded data
%   THRESHOLD, a velocity threshold in mm/s
%   F, Capture Frequency
% 
%   Returns 
%   TIME_EVENT, Timing of event in ms
%
%   Example
%   time_event = RTMoCap_3Devent(data(:,:,1),20,200) 
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

% History:
% Version 1.0 - Daniel Lewkowicz - 08-2014

function time_event = RTMocap_3Devent(A,threshold,F)

    % Nothing fancy here, just a simple find function
    time_event=find(RTMoCap_3Dvel(A,F)>threshold,1,'first')*1000/F;

end