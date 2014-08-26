% RTMOCAP_INTERP Apply a spline interpolation for missed frames
% 
%  This function will help you to interpolate data (fill-gap) on missed 
%  frames due to occlusions or computational delays. The main prupose of
%  this function is to remove NaNs and reconstruct timings of samples.
% 
%   Usage: data_i = RTMoCap_interp(data,time,Fs)
% 
%   DATA, a data matrix
%   TIME, a recorded time vector
% 
%   Returns 
%   DATA_I, Interpolated data matrix
%
%   Example:
%   data_i = RTMoCap_interp(data,time) 
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

function data_i = RTMoCap_interp(data,time,Fs)

% Disable warnings for NaN values
warning('off','MATLAB:chckxy:IgnoreNaN');
warning('off','MATLAB:interp1:NaNinY');

nb_samples=size(data,1);

% Rebuild frame number from time vector
num_frame=((time(:,1)-time(1,1))/1000*Fs)+1;

% Missing data ? interpolation
data_i=zeros(size(data));

for j=1:size(data,3)      
        %if data is not all NaNs 
        if sum(isnan(data(:,:,j))) ~= nb_samples
            % perform spline interpolation
            data_i(:,:,j)=interp1(num_frame,data(:,:,j),(1:nb_samples)','spline');
        end
end 


% Enable warnings for NaN values before leaving
warning('on','MATLAB:chckxy:IgnoreNaN');
warning('on','MATLAB:interp1:NaNinY');
 
end
