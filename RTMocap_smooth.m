% RTMOCAP_SMOOTH Apply a low-pass Butterworth filter
% 
%  This function will help you to smooth your data with an appropriate
%  filter suited for human motion capture. (See Winter, 1990)
% 
%   Usage : DATA_SM = RTMocap_smooth(DATA,Fs,Fc,order)
% 
%   DATA, a N-by-3-by-M matrix of recorded data, with N the number of
%   samples and M the number of markers
%   FS, Sampling Frequency
%   FC, Cut-off frequency
%   ORDER, The order of the filter 
% 
%   Returns 
%   DATA_SM, Smoothed N-by-3-by-M Data matrix 
%
%   Example
%   data_sm = RTMocap_smooth(data,200,10,4) 
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
% Version 1.1 - D.L. - Added a residual plot to select FC - 11-2014

function data_sm = RTMocap_smooth(data,Fs,FC)

% Add library folder to current path
% addpath([cd '\lib']);

if nargin < 2 
    Fs=input('Please input the sampling frequency (Hz): ');
end

if nargin < 3
    %help you find the better cut-off frequency
    vel=RTMocap_3Dvel(data,Fs);
    for i=1:Fs/2
        vel_sm_all(:,i,:)=RTMocap_smooth(vel,Fs,i);
        res=vel_sm_all(:,i,:)-vel;
        res_vel(i,:)=sum(res.^2)/size(vel_sm_all,1);
        for j=1:size(res_vel,2)
            [auto_corr,lags]=xcorr(res(:,:,j),'coeff');
            A(i,j)=sum(auto_corr(lags>0).^2);
        end    
    end
     
% Initializing color map
    mcol=1:floor(64/size(data,3)):64;
    
    figure('Color',[1 1 1]);
    col=jet;
    hold on
    
    % Initialize plot for legend
    for j=1:size(res_vel,2)
        plot(res_vel(1,j),'DisplayName',['Marker:',num2str(j)],'Color',col(mcol(j),:));
    end
    
    legend(gca,'show');
        
    % plot all residuals
    for j=1:size(res_vel,2)
        plot(1:Fs/2,res_vel(:,j),'color',col(mcol(j),:));
        [~,xFc(j)]=min(A(:,j));
        plot(xFc(j),res_vel(xFc(j),j),'*','color',col(mcol(j),:));
    end    
    
    legend(gca,'show');
    title({'Residual Plot','The * indicates the optimal lowpass frequency',['(Recommended: ',num2str(mean(xFc),2),'Hz)']},'FontSize',8)
    xlabel('Lowpass Cut-off Frequency (Hz)')
    ylabel('Residuals: Signal Distortion')
    ylim([-100 Fs*10]);
    xlim([0 Fs/2]);
  
    FC=input(['Please input the lowpass cut-off frequency (Recommended: ',num2str(mean(xFc),2),'Hz): ']);
    if isempty(FC);FC=10;end
    
    close;
end

% if nargin < 4 
%     order=input('Please input the order of the filter: ');
%     if isempty(order);order=2;end
% end

data_sm=zeros(size(data));

for j=1:size(data,3)
    % filtfilt doubles the order (forward and backward pass)
    [B,A] = butter(2, FC * 2/Fs );
    data_sm(:,:,j) = filtfilt(B,A,data(:,:,j));
end    


end

