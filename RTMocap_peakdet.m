% RTMOCAP_Peakdet Detect Peaks in Signal
% 
%  This function will help you to detect local minima and maxima in a
%  one-dimensinal vector
% 
%   Usage : [MAXTAB MINTAB]=RTMocap_peakdet(V, DELTA)
%   
%   V, a N-by-1 vector. Usually, a velocity profile as the output of the
%   RTMocap_3Dvel function.
% 
%   MAXTAB and MINTAB contain two columns. Column 1 contains indices in V,
%   and column 2 the found values.
%
%   Example
%   [maxv minv]=RTMocap_peakdet(V,100) 
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

function [maxtab, mintab]=RTMocap_peakdet(v, delta)

maxtab = [];
mintab = [];

if nargin<2 
    delta=input('Please input minimum delta between min and max values: ');
end

if delta <= 0
  error('DELTA must be positive');
end

mx=-Inf; mn=Inf;
imx=NaN; imn=NaN;

found=1;

    for i=1:size(v,1)
        if v(i) > mx 
            mx = v(i); 
            imx = i;
        end
        if v(i) < mn
            mn = v(i);
            imn = i;
        end

        if found
            if v(i) < mx - delta
                maxtab = [maxtab ; imx mx];
                mn = v(i);
                imn = i;
                found=0;
            end
        else
            if v(i) > mn + delta
                mintab = [mintab ; imn mn];
                mx = v(i);
                imx = i;
                found=1;
            end
        end 
    end
    
end    