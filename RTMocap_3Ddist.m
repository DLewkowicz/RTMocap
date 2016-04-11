%% RTMoCap_3Ddist
% This function will help you to compute relative position between two
% markers in the 3D space.
% 
%       Usage : C = RTMocap_3Ddist(A,B)
% 
%       A and B N-by-3 arrays of recorded data
%       C is a N-sized vector. 
%       
%       Principle: In a cartesian coordinate system if A and B are two 
%       points defined in the euclidean space, the distance from A to B 
%       is given by : dist_a_b = sqrt((Ax-Bx)^2 + (Ay-By)^2 + (Az-Bz)^2) 
% 
%       pdist2 is a more general but slower version of this function 
%       and only available with the Statistical Toolbox (c)Mathworks.
% 
%       NOTE: This very same function can be used to compute many
%       parameters
% 
%       1) The total traveled distance if you do not specify B
%       Example
%       dist_travelled = RTMocap_3Ddist(data);
% 
%       2) The distance between two unique points (N=1) 
%       Example
%       dist1_2_marker1 = RTMocap_3Ddist(data(1,:,1),data(2,:,1));
% 
%       3) The relative distance of each sample from an initial position
%       or from any other reference point
%       Example
%       init_dist1=RTMocap_3Ddist(data(1,:,1),data(:,:,1))
%
%       4) the point-to-point distance between two markers.
%       Example
%       dist1_2=RTMocap_3Ddist(data(:,:,1),data(:,:,2))
%
% 
% Copyright (C) 2014 Daniel Lewkowicz <daniel.lewkowicz@gmail.com>
% RTMocap Toolbox available at : http://sites.google.com/RTMocap
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
% Version 1.1 - D.L - Add total distance travelled 04-2016

function C = RTMocap_3Ddist(A,B)

if nargin<2 
    C = sum(sqrt(sum(diff(A).^2,2)),1);
    return
end

if size(A,1)~=size(B,1)
% When comparing a trajectory versus a unique point
 if size(B,1)==1
    % Replicate the array to match the size of other
    B=repmat(B,size(A,1),1);
 elseif size(A,1)==1
    A=repmat(A,size(B,1),1);
 else
    % To compare two trajectories, it requires an equal number of points	  
 error('3Ddist: Matrix dimensions must agree.');
 end
end

% Euclidean distance - fastest and easiest solution
    C=sqrt(sum((A-B).^2,2));              
end                        
