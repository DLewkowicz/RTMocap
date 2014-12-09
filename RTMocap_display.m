% RTMOCAP_DISPLAY Plots the trajectory in 3D and the velocity profile 
% 
%  This function will help you to compute the first moment in time when 
%   a specific velocity threshold has been reached 
% 
%   Usage : RTMocap_display(data,Fs)
% 
%   DATA, a N-by-3-by-M matrix of recorded data, with N the number of
%   samples and M the number of markers
%   Fs, Capture Frequency
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

function RTMocap_display(data,Fs,m_disp)

if nargin<2 
    Fs=input('Please input the sampling frequency (Hz): ');
    if Fs<0
        error('Sampling Frequency must be positive');
    end
end

if nargin<3
    m_disp=input('Please input the number of the marker to display kinematic information: ');
    if m_disp<0
        error('Marker number must be positive');
    end
end

    % rebuild time axis in ms
    xi(:,1)=1:size(data,1)-1;
    
    % get screensize => [1, 1, width, height]
    scrsz = get(0,'ScreenSize');
    
    % Initializing color map
    mcol=1:floor(64/size(data,3)):64;
    
    % Right side [left, bottom, width, height]
    figure('Position',[scrsz(3)/2 scrsz(4)*1/4 scrsz(3)/2 scrsz(4)/2],'Color',[1 1 1])
    col=jet;
    hold on
    for M=1:size(data,3)
        vel=RTMocap_3Dvel(data(:,:,M),Fs);
        % plot the velocity profile 
        plot(xi*1000/Fs,vel,'Color',col(mcol(M),:),'DisplayName',['Marker: ',num2str(M)]);
    end
    
    title('Velocity profiles');
    xlabel('Time (ms)'), ylabel('Speed (mm/sec)');
    % Legend is displayed in the 3Dplot
    % legend(gca,'show');
    
    % Retrive kinematic parameters
    ktab=RTMocap_kinematics(data(:,:,m_disp),Fs);
    
    % display reaction time
    plot(ktab.start(1),20,'g*');
    text(ktab.start(1),20,['RT:',num2str(ktab.start(1)),'ms'],'HorizontalAlignment','right','VerticalAlignment','bottom')
    
    % total number of movements
    nb_elmt=size(ktab.start,2);
    
    
for i=1:nb_elmt
           
    % display peaks of velocity
    plot(ktab.TPV(i)+ktab.start(i),ktab.APV(i),'r*');
    text(ktab.TPV(i)+ktab.start(i)+50,ktab.APV(i),['APV: ',num2str(ktab.APV(i),'%.0f'),'mm/s'])
    
    % display movement time
    plot(ktab.start(i),ktab.APV(i)*1.2,'k*'),plot(ktab.start(i)+ktab.MT(i),ktab.APV(i)*1.2,'k*');
    line([ktab.start(i),ktab.start(i)+ktab.MT(i)],[ktab.APV(i)*1.2,ktab.APV(i)*1.2]);
    text(ktab.start(i)+ktab.TPV(i),ktab.APV(i)*1.2+50,['MT: ',num2str(ktab.MT(i)),'ms'],'HorizontalAlignment','center','Color','b');
end

    figure('Position',[1 scrsz(4)*1/4 scrsz(3)/2 scrsz(4)/2],'Color',[1 1 1])
    hold on
    col=jet;
    for M=1:size(data,3)    
        % and the 3Dplot on the Left side
        plot3(data(:,1,M),data(:,2,M),data(:,3,M),'Color',col(mcol(M),:),'DisplayName',['Marker: ',num2str(M)]);      
    end
    axis equal
    view([45 45]);
    title('Movements of markers in 3D Space');
    legend(gca,'show');
    
for i=1:nb_elmt
    
    start=round(ktab.start(i)/(1/Fs*1000));
    stop=round((ktab.start(i)+ktab.MT(i))/(1/Fs*1000));
    
    % display start and stop of movements
    if ~isnan(start)
        plot3(data(start,1,m_disp),data(start,2,m_disp),data(start,3,m_disp),'k*');
        plot3(data(stop,1,m_disp),data(stop,2,m_disp),data(stop,3,m_disp),'k*');
    end 
%     % display peaks of velocity position in 3Dplot
%     peak=(ktab.start(i)+ktab.TPV(i))/(1/Fs*1000);
%     plot3(data(peak,1,m_disp),data(peak,2,m_disp),data(peak,3,m_disp),'r*');
    
end    
    
    

end