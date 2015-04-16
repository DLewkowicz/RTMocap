% RTMOCAP_Kinematics Extract Kinematic parameters from data
% 
%  This function will help you to extract a large number of Kinematic
%  parameters from a data_file
% 
%   Usage : [kinematic_table,vel_profile] = RTMocap_Kinematics(DATA,FS)
% 
%   DATA, a N-by-3-by-M matrix of recorded data, with N the number of
%   samples and M the number of markers
%   FS, Sampling Frequency
% 
%   Returns 
%   KINEMATIC_TABLE, Table of kinematic parameters 
%
%   Example
%   [kinematic_table,vel_profile] = RTMocap_Kinematics(data,200)
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

function [kinematic_table,vel] = RTMocap_kinematics(data,Fs)

if nargin<2 
    Fs=input('Please input the sampling frequency (Hz): ');
end

% To get the Movement durations in ms
Timems=1000/Fs;

% Get velocity vector
vel=RTMocap_3Dvel(data,Fs);

% Get acceleration vector
% acc=RTMocap_3Dacc(data,Fs);

% Get height vector (z-axis)
height=data(:,3,:);

% Peak detection
[maxtab, mintab]=RTMocap_peakdet(vel,100);

% Movement segmentation for each bell shape curve
for i=1:size(maxtab,1)
    
    % Amplitude of Peak Velocity
    APV(i,1)=maxtab(i,2);

    % Going backward from peak to get the start of movement
    % More than 20mm/s = start of movement (e.g. Reaction Time)
    if i==1
        startT=maxtab(i,1)-find(vel(maxtab(i,1):-1:1)<=20,1,'first')+1;
        %not found ?
        if isempty(startT)
            start(i,1)=maxtab(i,1)-find(vel(maxtab(i,1):-1:1)==min(vel(maxtab(i,1):-1:1)),1,'first')+1;
        else
            start(i,1)=startT;
        end    
    else 
        startT=maxtab(i,1)-find(vel(maxtab(i,1):-1:stop(i-1))<=20,1,'first')+1;
        %not found ?
        if isempty(startT)
            start(i,1)=maxtab(i,1)-find(vel(maxtab(i,1):-1:stop(i-1))==min(vel(maxtab(i,1):-1:stop(i-1))),1,'first')+1;
        else
            start(i,1)=startT;
        end
    end

    
    % Time to Peak Velocity
    TPV(i,1)=maxtab(i,1)-start(i,1);

    % Movement Time - classical method
    if size(mintab,1)>=i
        % first, get the local minima
        MT(i,1)=mintab(i,1)-start(i,1);
    else
        MT(i,1)=NaN;
    end
    
    % Going forward from peak until finding next local minima
    % less than 20mm/s = end of movement
    stopT=find(vel(start(i,1)+TPV(i,1):end)<=20,1,'first')+start(i,1)+TPV(i,1)-1;
    if isempty(stopT) && size(maxtab,1)>i
        stop(i,1)=find(vel(start(i,1)+TPV(i,1):maxtab(i+1,1))==min(vel(start(i,1)+TPV(i,1):maxtab(i+1,1))),1,'first')+start(i,1)+TPV(i,1)-1;
    elseif isempty(stopT)
        stop(i,1)=find(vel(start(i,1)+TPV(i,1):end)==min(vel(start(i,1)+TPV(i,1):end)),1,'first')+start(i,1)+TPV(i,1)-1;
    else
        stop(i,1)=stopT;
    end    
    
    if isnan(MT(i,1)) || stop(i,1)-start(i,1)<MT(i,1)
        % if no local minima was found or after the end of the movement
        % -> recalculate movement time
        MT(i,1)=stop(i,1)-start(i,1);
    elseif stop(i,1)-start(i,1)>MT(i,1)
        % if the following movement starts without stop
        % -> stop position = local minima 
        stop(i,1)=start(i,1)+MT(i,1);
    end
   
    % Deceleration percentage
    DC(i,1)=(MT(i,1)-TPV(i,1))/MT(i,1);
    
    % Peak height & Time to peak height
    [APH(i,1),TPH(i,1)]=max(height(start(i,1):stop(i,1)));
        
    % Peak acceleration and Time to peak acceleration
    %[maxacc, ~]=RTMocap_peakdet(acc(start(i,1):stop(i,1)),2000);  
  
end 

% Total movement duration 
% MT_all=stop(end)-start(1);

% [start,stop,APV,TPV,MT,DC,APH,TPH];

for i=1:size(maxtab,1)
    kinematic_table.start(:,i)=start(i,1)*Timems;
    kinematic_table.stop(:,i)=stop(i,1)*Timems;
    kinematic_table.APV(:,i)=APV(i,1);
    kinematic_table.TPV(:,i)=TPV(i,1)*Timems;
    kinematic_table.MT(:,i)=MT(i,1)*Timems;
    kinematic_table.DC(:,i)=DC(i,1);
    kinematic_table.APH(:,i)=APH(i,1);
    kinematic_table.TPH(:,i)=TPH(i,1)*Timems;
end
    if ~exist('kinematic_table','var')
        kinematic_table.start=NaN;
        kinematic_table.stop=NaN;
        kinematic_table.APV=NaN;
        kinematic_table.TPV=NaN;
        kinematic_table.MT=NaN;
        kinematic_table.DC=NaN;
        kinematic_table.APH=NaN;
        kinematic_table.TPH=NaN;
    end
end