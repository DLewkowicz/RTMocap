% RTMOCAP_SMOOTH Apply a low-pass Butterworth filter
% 
%  This function will help you to smooth your data with an appropriate
%  filter suited for human motion capture. (See Winter, 1990)
% 
%   Usage : data_smooth = RTMocap_smooth(table,Fs,F0,order)
% 
%   TABLE, a N-by-3 recorded data table (1 marker)
%   FS, Sampling Frequency
%   F0, Cut-off frequency
%   ORDER, The order of the filter 
% 
%   Returns 
%   TABLE_SM, Smoothed Data Table (only 1 marker)
%
%   Example
%   data_smooth = RTMocap_smooth(data,200,10,4) 
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

function data_sm = RTMocap_smooth(data,Fs,F0,order)

% Add library folder to current path (Octave GPL code: butter, filtfilt, ...)
addpath([cd '\lib']);

if nargin==1 
    Fs=input('Please input the sampling frequency (Hz): ');
    
elseif nargin == 2   
    F0=input('Please input the lowpass cut-off frequency (Hz): ');
    if isempty(F0);F0=10;end

elseif nargin == 3 
    order=input('Please input the order : ');
    if isempty(order);order=4;end
end

data_sm=zeros(size(data));

for j=1:size(data,3)
    % filtfilt doubles the order (forward and backward pass)
    [B,A] = butter(order/2, F0 * 2/Fs );
    data_sm(:,:,j) = filtfilt(B,A,data(:,:,j));
end    

% clean current path
rmpath([cd '\lib']);

end

