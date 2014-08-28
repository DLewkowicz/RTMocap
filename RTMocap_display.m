% RTMOCAP_DISPLAY Plots the velocity profile and the 3D representation
% 
%  This function will help you to compute the first moment in time when 
%   a specific velocity threshold has been reached 
% 
%   Usage : RTMocap_display(data,F)
% 
%   DATA, a N-by-3-by-M matrix of recorded data, with N the number of samples
%   F, Capture Frequency
%
%   Example
%   RTMoCap_display(data(:,:,1),200) 
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

function RTMocap_display(data,F)

    % rebuild time axis in ms
    xi(:,1)=1:size(data,1)-1;
    
    % get screensize => [1, 1, width, height]
    scrsz = get(0,'ScreenSize');
    
    % Initializing color map
    col=jet;
    mcol=1:floor(64/size(data,3)):64;
    
    % Right side [left, bottom, width, height]
    figure('Position',[scrsz(3)/2 scrsz(4)*1/4 scrsz(3)/2 scrsz(4)/2])
    hold on
    for M=1:size(data,3)
        % plot the velocity profile 
        plot(xi*1000/F,RTMoCap_3Dvel(data(:,:,M),F),'Color',col(mcol(M),:));
    end
         
    figure('Position',[1 scrsz(4)*1/4 scrsz(3)/2 scrsz(4)/2])
    hold on
    for M=1:size(data,3)    
        % and the 3Dplot on the Left side
        plot3(data(:,1,M),data(:,2,M),data(:,3,M),'Color',col(mcol(M),:));
    end
    axis square
    view([45 45]);

end