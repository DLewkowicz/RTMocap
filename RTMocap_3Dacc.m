%% RTMoCap_3Dacc
% This function will help you to compute instantaneous acceleration 
% 
% Usage : ACC = RTMocap_3Dacc(DATA,Fs)
% 
%       DATA is N-by-3 array of recorded data
%       Fs is the sampling frequency
%       ACC is a N-by-1 vector.
% 
%       Principle: Assuming that each measurement is seaparated by the 
%       exact same amount of time (i.e. interpolated data), 
%       the instantaneous acceleration is simply given by: 
% 
%           a = sqrt((d²x/d²T)^2 + (d²y/d²T)^2 + (d²z/d²T)^2)
% 
%   Example
%	ACC = RTMocap_3Dacc(data,200)
% 
% Copyright (C) 2014 Daniel Lewkowicz <daniel.lewkowicz@gmail.com>
% RTMocap Toolbox available at : http://sites.google.com/RTMocap/
% 
% This program is free software; you can redistribute it and/or modify it
% under the terms of the GNU General Public License as published by the
% Free Software Foundation; either version 3 of the License, or any later 
% version.
% 
% This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
% Public License for more details.
% 
% You should have received a copy of the GNU General Public License along
% with this program; if not, see <http://www.gnu.org/licenses/>.

% History:
% version 1.0 - Daniel Lewkowicz - 08-2014
% version 1.1 - D.L. minor corrections in comments - 04-2016

function acc = RTMocap_3Dacc(A,Fs)

if nargin<2 
    Fs=input('Please input sampling frenquency (Hz): ');
    if Fs<=0
        error('Fs must be positive');
    end    
end

    %First calculate dx, dy and dz
for i=1:size(A,3)    
    dx(:,i)=diff(A(:,1,i))*Fs;
    dy(:,i)=diff(A(:,2,i))*Fs;
    dz(:,i)=diff(A(:,3,i))*Fs;
    dA(:,:,i)=[dx(:,i),dy(:,i),dz(:,i)];
end
    %then compute euclidean distance of two sucessive dx,dy and dz
    acc=sqrt(sum(diff(dA).^2,2))*Fs;
    
end