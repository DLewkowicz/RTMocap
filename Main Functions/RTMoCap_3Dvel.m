%% RTMoCap_3Dvel
% This function will help you to compute instantaneous tangential velocity 
% 
% Usage : V = RTMoCap_3Dvel(A,F)
% 
%       A is a N-by-3 array of recorded data.
%       F is the capture frequency
%       V is a N-by-1 vector.
% 
%       Principle: Assuming that each measurement is seaparated by the 
%       exact same amount of time (i.e. interpolated data), 
%       the instantaneous velocity is simply given by: 
%           V = dS / dT 
%       S being the length of the path travelled until time T
% 
%   Example
%	V = RTMoCap_3Dvel(data(:,:,1),200)
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

function V = RTMoCap_3Dvel(A,F)
    % First order derivative of euclidean distance in 3D Space
    V=sqrt(sum(diff(A).^2,2))*F;
end