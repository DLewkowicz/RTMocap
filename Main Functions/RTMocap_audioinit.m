% RTMOCAP_AUDIOINIT Returns a series of preloaded Audioplayer objects
% 
%       HIGH : high pitch
%       LOW : low pitch
%       COIN : positive reward
%       SPIT : negative reward
%       FUNK : end of block 
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
 
function [high,low,coin,spit,funk] = RTMocap_audioinit()

% AUDIO PLAYER PRELOADING
f=wavread('funk.wav');
c=wavread('coin.wav');
s=wavread('spit.wav');

coin=audioplayer(c,16000);
spit=audioplayer(s,11025);
funk=audioplayer(f,22050);

% ARTIFICIAL SOUNDS
sinus=1:1000;
high=audioplayer(repmat(sin(sinus'),2,1),11025);
low=audioplayer(repmat(sin(sinus'/4)*2,2,1),11025);

% % % % % % % % % % % % % % % % % % % % % % % 
% SOUND EXAMPLES
% Execute [high,low,coin,spit,funk] = RTMocap_audioinit() in command window
% then one of the following lines.
% 
% play(high); 
% play(low);
% play(coin);
% play(spit);
% play(funk);

end