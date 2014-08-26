% RTMOCAP_PAUSEREF Set a Reference Point
% 
% This function will help you to set a point as a reference pause position.
% 
%   Usage : [ref] = RTMocap_pauseref(name,n_pause,num,Fs)
% 
%   NAME: The name of the marker
%   N_PAUSE: Ordinal number of the pause during the movement sequence
%   NUM : The marker ordinal number in marker list
% 
%   Returns 
%   REF: Reference pause position as a 1x3 array, [X Y Z]
%
%   Example
%   [ref] = RTMocap_pauseref('Index',1,4,200) 
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

function [ref] = RTMocap_pauseref(name,npause,num,Fs)

% Qualisys config file
q=QMC('QMC_conf.txt');
close all;

% Infinite loop until reference position has been calibrated
while exist('ref','var')==0

    disp(['Place the [',name,'] marker on PAUSE position n�', num2str(npause),' and Press a key']);
    pause;
    
% Calibration duration : half a second
    m=zeros(Fs/2,3);
    for i=1:Fs/2
        disp('Calibration...');
        [labels,~]=QMC(q);
        m(i,:)=labels(:,num)';
    end
    
% Check if marker was occluded    
if any(isnan(m))
    answer=input('NaNs in data, Would you like to calibrate this postition again ? y/n ','s');
    if answer == 'y'
        % restart loop
        continue;
    end    
end

% Check if marker has moved
test2=RTMoCap_3Dvel(m,Fs);
plot(test2);
figure;
plot3(m(:,1),m(:,2),m(:,3));
axis square;

if any(RTMoCap_3Dvel(m,Fs)>20)    
    answer=input('Movement detected, Would you like to calibrate this postition again ? y/n ','s'); 
    if answer == 'y'
        % restart loop
        continue;
    end
end 

% else compute reference position
ref=mean(m);  

end

end
