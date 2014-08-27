%% RTMoCap_3Ddist
% This function will help you to compute relative position between two
% markers in the 3D space.
% 
%       Usage : C = RTMoCap_3Ddist(A,B)
% 
%       A and B are arrays of N-by-3 dimensions.
%       C is a N-sized vector. The same function can be used to
%       compute distance between two points (N=1) or two mobile markers. 
%
%       Principle: In a cartesian coordinate system if A and B are two 
%       points defined in the euclidean space, the distance from A to B 
%       is given by :
%       d(A, B) = sqrt((A_X - B_X)^2 + (A_Y - B_Y)^2+(A_Z - B_Z)^2) 
% 
%       pdist2 is a more general but slower version of this function 
%       and only available with the Statistical Toolbox (c)Mathworks.
% 
% Copyright (C) 2014 Daniel Lewkowicz <daniel.lewkowicz@gmail.com>
% RTMocap Toolbox available at : http://sites.google.com/RTMocap

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


function C = RTMocap_3Ddist(A,B)

if size(A,1)~=size(B,1)
% When comparing a trajectory versus a point
 if size(B,1)==1
    % Replicate array to match the size of other
    B=repmat(B,size(A,1),1);
 elseif size(A,1)==1
    A=repmat(A,size(B,1),1);
 else
    % When comparing two trajectory, requires equal numer of points	  
 error('3Ddist: Matrix dimensions must agree.');
 end
end

% Euclidean distance - fastest and easiest solution
    C=sqrt(sum((A-B).^2,2));              
end                        
