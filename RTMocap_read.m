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
%   data=RTMocap_read('Raw_data_001.txt') 
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
% Version 1.1 - D.L - 02-2016 - Add support for time vector included in data files -  Thanks to N. Carvahlo

function data=RTMocap_read(filename,timevec)

if nargin<2
 if exist ('timevec', 'var')
	if isinteger(timevec) && timevec >= 0
	else
		error('timevec error: column number must be positive');
	end
 else
    timevec=0;
 end
end


% Read the txt
tmp=dlmread(filename);

% Select data colums
table=tmp(:,timevec+1:end);
nb_m=size(table,2)/3;

% if data_tmp doesnt have correct number of columns, is there a time vector ?
if floor(nb_m)~=ceil(nb_m)
  timevec_present=input('Wrong number of columns detected, did you include time vector during export ? (y/n) ','s');
  if timevec_present=='y'
	% If timevec is present, we will find it
    	Fs=input('Please input the sampling frequency (Hz): ');
   	
	% Check all columns for something that should look like a time vector for the appropriate sampling frequency
	% time=(1:1/Fs*1000:1/Fs*1000*size(table,1))';
    	for col = 1:size(table,2)
		Observed_Fs=1/mean(diff(table(:,col)));
		% can tolerate 1-5 Hz of error, escially if a small amount of frames are missing
		if Fs-Observed_Fs < 5
			timevec=col;
			break;
		end
	end
	
	if col==size(table,2) && Fs-Observed_Fs >= 5
		error('Cannot locate time vector in your data file, you try again by manually input the column number using "RTMocap_read(filename,colnum)')
	end

  data=RTMocap_read(filename,timevec);
  %Export data files and time
  export=input('Success! Time vector located and Data correctly read, would you like to export the new data and time files ? (y/n) ','s');
	if export=='y'
		dlmwrite(['data_',filename],table(:,timevec+1:end));
		% Note :time files are in millisec in RTMocap
		dlmwrite(['time_',filename],table(:,timevec)*1000);
	end
	return;
  else 
    error('Data file must have M*3 columns');
end
end


% Preload the N-by-3-by-M matrix
data=zeros(size(table,1),3,nb_m);

% Fetch with data
for m=1:size(table,2)/3 
    data(:,:,m)=table(:,m*3-2:m*3);
end

end
