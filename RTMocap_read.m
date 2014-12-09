% RTMOCAP_READ Read the txt file and fetch the a N-by-3-by-M matrix
% 
%  This function will help you to read the content of a pre-recorded file
% 
%   Usage : data=RTMocap_read('filename')
%   
%   FILENAME, a previously recorded .txt file
%
%   RETURNS:
%   DATA, a N-by-3-by-M matrix of recorded data, with N the number of
%   samples and M the number of markers
%   
%
%   Example
%   data=RTMocap_read('Raw_data_001.txt',200) 
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

function data=RTMocap_read(filename)

% Read the txt
tmp=dlmread(filename);
nb_m=size(tmp,2)/3;

% if data_tmp doesnt have enough columns, then something is wrong
if floor(nb_m)~=ceil(nb_m)
    error('Data file must have M*3 columns');
end    

% Preload the N-by-3-by-M matrix
data=zeros(size(tmp,1),3,nb_m);

% Fetch with data
for m=1:size(tmp,2)/3 
    data(:,:,m)=tmp(:,m*3-2:m*3);
end


end
