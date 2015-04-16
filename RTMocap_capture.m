% RTMOCAP_CAPTURE Capture samples and timestamps
% 
% This function will help you to capture all markers for a predefined
% amount fo time
% 
%   Usage : [data,time] = RTMocap_capture(duration,F,M,n_rec,cam)
% 
%   DURATION, Capture duration in seconds
%   F, Capture frequency
%   M, Number of markers to capture
%   N_REC, Recording number
%   CAM, matlab link for camera system (ex: qualisys)
% 
%   Returns 
%   DATA, Reference pause position as a N-by-3-by-M matrix, with N the
%   number of samples and M the number of markers
%   TIME, N-by-2 array with timing information for each sample in
%   millisecond
%
%   Example
%   [data,time] = RTMocap_capture(400,6,1,qualisys)
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

% History : 
% version 1.0 - Daniel Lewkowicz - 08-2014

function [data,time] = RTMocap_capture(duration,F,M,n_rec,cam)

N=duration*F;
data=zeros(N,3,M);
time=zeros(N,1);

if strcmp(cam,'qualisys')
    % capture - Qualisys version
    for i = 1:N
        disp(['Capture n° ',num2str(n_rec)]);
        [labels,~]=QMC(cam);
        time_temp(1:2)=QMC(cam,'frameinfo');
        time(i,1)=time_temp(2)/1000-time(1,1);

        for x=1:M
            data(i,:,x)=labels(:,x)'; % ALL MARKERS
        end   

    end
    
elseif strcmp(cam,'vicon')
    % capture - Vicon version
    for i=1:N
        vicon.GetFrame();
        nb_subj=vicon.GetSubjectCount();
        x=1;
        for s=0:nb_subj-1
            name=vicon.GetSubjectName(s);            
            nb_m=vicon.GetMarkerCount(cellstr(name.SubjectName));
            for m=0:nb_m-1
                m_name=vicon.GetMarkerName(cellstr(name.SubjectName),m);
                tmp_d = vicon.GetMarkerGlobalTranslation(cellstr(name.SubjectName),cellstr(m_name.MarkerName));
                tmp_t  = vicon.GetTimecode();
                
                data(i,:,x) = tmp_d.Translation;
                time(i)= tmp_t.Seconds;
                x=x+1;
            end
        end    
    end

elseif strcmp(cam,'optotrak')
    
for i = 1:N    
    %data=optotrak('DataGetLatest3D',M);
    [RealtimeDataReady,SpoolComplete,SpoolStatus,FramesBuffered]=optotrak('DataBufferWriteData');
  
    if(RealtimeDataReady)
        tmp_d=optotrak('DataReceiveLatest3D',coll.NumMarkers);

        for m=1:M
            data(i,:,m)=[tmp_d.Markers{m}(1),tmp_d.Markers{m}(2),tmp_d.Markers{m}(3)];
        end
    end
    
    optotrak('RequestLatest3D');
    RealtimeDataReady = 0;
end


elseif strcmp(cam,'kinect')
    
    % by default, kinect depth sensor is nunmber 2
    % use info = imaqhwinfo('kinect'); to verify this number
    vid = videoinput('kinect',2,'Depth_640x480');
    
    vid.FramesPerTrigger = N;
    
    start(vid);
    
    % Kinect output for each actor return a 20
    % This is the order of the joints returned by the Kinect adaptor:
    % 
    %    Hip_Center = 1;
    %    Spine = 2;
    %    Shoulder_Center = 3;
    %    Head = 4;
    %    Shoulder_Left = 5;
    %    Elbow_Left = 6;
    %    Wrist_Left = 7;
    %    Hand_Left = 8;
    %    Shoulder_Right = 9;
    %    Elbow_Right = 10;
    %    Wrist_Right = 11;
    %    Hand_Right = 12;
    %    Hip_Left = 13;
    %    Knee_Left = 14;
    %    Ankle_Left = 15;
    %    Foot_Left = 16; 
    %    Hip_Right = 17;
    %    Knee_Right = 18;
    %    Ankle_Right = 19;
    % When BodyPosture is set to Standing, all 20 indices are returned.
    % When BodyPosture is set to Seated, numbers 2 through 11 are returned, since this represents the upper body of the skeleton.
    
    
    for i = 1:N
        
    [frame, ts, metaData] = getdata(vid);
    
        for m = 1:M
            data(i,:,m)=metaData(i).JointWorldCoordinates(m,:,1);
            time(i)=ts;
        end
        
    end     
end



end