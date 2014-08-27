% RTMOCAP_CAPTURE Capture samples and timestamps and check pause positions
% 
% This function will help you to capture and check within capture if pause
% position has been reached. The delay for each Pause position have to be 
% predefined through the RTMocap_design function.
% 
%   Usage : [data,time,outside] = RTMocap_capture(nb_samples,nb_markers,marker_table,n)
% 
%   NB_SAMPLES, Number of samples
%   NB_MARKERS, Number of markers to capture
%   MARKER_TABLE, Array : [MARKER_NUM,RADIUS,DURATION] (see: RTMocap_design) 
%   N, Recording number
% 
%   Returns 
%   DATA, Reference pause position as a Nx3xM matrix, [X Y Z] with N the
%   number of samples and M the number of markers
%   TIME, Nx2 array with timing information for each sample
%   OUTSIDE, A boolean for pause verifications within sequence
%
%   Example
%   [data,time] = RTMocap_capture(nb_samples,nb_markers,marker_table,n)
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

function [data,time] = RTMocap_capturep(nb_samples,nb_markers,marker_table,n)

data=zeros(nb_samples,3,nb_markers);
time=zeros(nb_samples,2);
inside=0;
outside=0;
k=2;

% Qualisys config file
q=QMC('QMC_conf.txt');

% capture
for i = 1:nb_samples
    disp(['Capture n° ',num2str(n)]);
    [labels,~]=QMC(q);
    time(i,1:2)=QMC(q,'frameinfo');
    
    for x=1:nb_markers
        data(i,:,x)=labels(:,x)'; % ALL MARKERS
    end   

%% if pauses
if size(marker_table,1)>1       
    error=RTMocap_3Ddist(data(i,:,marker_table(k,1)),marker_table(k,2));
    
    % check for inside marker virtual sphere near pause reference
    if inside==0  
        if error<marker_table(k,2)
            inside=1;
            start_pause=i;
        end    
    end

    % if inside: check if marker go outside before delay 
    if inside==1 && i<start_pause+marker_table(k,3)
        if error>marker_table(k,2)
            % if outside before delay, send negative and stop record
            play(spit);
            break;
        end
        
    % else (after delay) send sound and move to next pause position        
    elseif inside==1 && outside==0
        play(high);
        outside=1;
        k=k+1;
    end
end

% end of capture loop
end

end