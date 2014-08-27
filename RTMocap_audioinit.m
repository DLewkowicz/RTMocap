% RTMOCAP_AUDIOINIT Returns a series of preloaded Audioplayer objects
% 
% Usage: audio = RTMocap_audioinit
% 
% Sound description:
%       HIGH, high pitch
%       LOW, low pitch
%       ENDB, end of block
%       COIN, positive
%       SPIT, negative
%       FUNK, end of block 
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
 
function audio = RTMocap_audioinit()

%Engaging sounds
f=wavread('.\audio\funk.wav');
c=wavread('.\audio\coin.wav');
s=wavread('.\audio\spit.wav');

% Audio Player preloading
coin=audioplayer(c,16000);
spit=audioplayer(s,11025);
funk=audioplayer(f,22050);

%Artificial sounds
xi=1:1000;
s_high=[sin(xi) zeros(1,2000)];
s_low=[sin(xi/4)*2 zeros(1,2000)];
s_endb=[repmat(s_low,1,2) zeros(1,2000) repmat(s_high,1,3)];

% Audio Player preloading
high=audioplayer(s_high,11025);
low=audioplayer(s_low,11025);
endb=audioplayer(s_endb,11025);

% Creating structure with audioplayer objects
audio=struct('internalObj',[],'stopper',[],'signal',[]');
audio(1,1)=struct(high);
audio(1,2)=struct(low);
audio(1,3)=struct(endb);
audio(2,1)=struct(coin);
audio(2,2)=struct(spit);
audio(2,3)=struct(funk);

% % % % % % % % % % % % % % % % % % % % % % % 
% SOUND EXAMPLES
% Execute audio = RTMocap_audioinit in command window
% then one of the following lines. Uncomment first (CTRL-T)

% play(audio(1,1).internalObj); % high
% play(audio(1,2).internalObj); % low
% play(audio(1,3).internalObj); % endb
% play(audio(2,1).internalObj); % coin
% play(audio(2,2).internalObj); % spit
% play(audio(2,3).internalObj); % funk

end