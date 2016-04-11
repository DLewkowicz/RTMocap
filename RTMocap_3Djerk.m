%% RTMoCap_3Djerk
% This function will help you to compute instantaneous jerk as well as
% popular measures of jerk.
% 
% Usage : [jerk,msqj,dlj] = RTMocap_3Djerk(DATA,Fs)
% 
%       DATA is N-by-3 array of recorded data
%       Fs is the sampling frequency
%       JERK is a N-by-1 vector
%       MSQJ is a scalar (1-by-1) value
%       DLJ is a scalar (1-by-1) value
% 
%       Principle: Assuming that each measurement is seaparated by the 
%       exact same amount of time (i.e. interpolated data), the 
%       norm of the jerk vector in 3D is given by: 
% 
%           j = sqrt((d³x/d³T)^2 + (d³y/d³T)^2 + (d³z/d³T)^2)
%
%       This value can only be positive and its reference frame is relative
%       to the current position of the marker.
%
%   Additionally, some popular measures of jerk include:
%   
%   The Mean Squared Jerk 
%   MSQJ = sum(j²)*dt/duration 
%   
%   duration being the total movement time
%   However, this value monotonically decrease with movement duration 
%   because of its dimension (L²/T⁶) see: Hogan & Sternad (2009)     
%
%   The Dimensionless jerk 
%   DLJ = sum(j²)*dt*duration⁵*amplitude²
% 
%   amplitude being the total distance travelled
%   This value has been found as a more accurate measure of smoothness
%
%   Example
%	[jerk,msqj,dlj] = RTMoCap_3Djerk(data,200)
% 
% Copyright (C) 2016 Daniel Lewkowicz <daniel.lewkowicz@gmail.com>
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
% version 1.0 - Daniel Lewkowicz - 04-2016

function [jerk,msqj,dlj] = RTMocap_3Djerk(A,Fs)

if nargin<2 
    Fs=input('Please input sampling frenquency (Hz): ');
    if Fs<=0
        error('Fs must be positive');
    end    
end

    %First calculate dx, dy and dz
for i=1:size(A,3)    
    ddx(:,i)=diff(diff(A(:,1,i)))*Fs.^2;
    ddy(:,i)=diff(diff(A(:,2,i)))*Fs.^2;
    ddz(:,i)=diff(diff(A(:,3,i)))*Fs.^2;
    ddA(:,:,i)=[ddx(:,i),ddy(:,i),ddz(:,i)];
end
    %then compute euclidean distance of two sucessive ddx,ddy and ddz
    jerk=sqrt(sum(diff(ddA).^2,2))*Fs;
    
    % mean squared jerk
    duration = size(A,1)/Fs;
    msqj = sum(jerk.^2)/Fs/duration;
    
    % dimensionless jerk    
    amplitude = RTMocap_3Ddist(A);
    dlj = sum(jerk.^2)./Fs.*(duration.^5)./(amplitude.^2);
    
end
