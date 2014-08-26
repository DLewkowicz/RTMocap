% RTMOCAP_CAPTURE Capture samples and timestamps
% 
% This function will help you to capture all markers for a predefined
% amount fo time
% 
%   Usage : [data,time] = RTMocap_capture(duration,F,n_rec)
% 
%   DURATION, Capture duration in seconds
%   F, Capture frequency
%   M, Number of markers to capture
%   N_REC, Recording number
% 
%   Returns 
%   DATA, Reference pause position as a N-by-3-by-M matrix, with N the
%   number of samples and M the number of markers
%   TIME, N-by-2 array with timing information for each sample in
%   millisecond
%
%   Example
%   [data,time] = RTMocap_capture(400,6,1)
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

function [data,time] = RTMocap_capture(duration,F,M,n_rec)

N=duration*F;
data=zeros(N,3,M);
time=zeros(N,1);

% Qualisys config file
q=QMC('QMC_conf.txt');

% capture
for i = 1:N
    disp(['Capture n° ',num2str(n_rec)]);
    [labels,~]=QMC(q);
    time_temp(1:2)=QMC(q,'frameinfo');
    time(i,1)=time_temp(2)/1000;
   
    for x=1:M
        data(i,:,x)=labels(:,x)'; % ALL MARKERS
    end   

end

end