% RTMOCAP_REWARD 
% 
%  This function will help you to reward the participant with perceptibles
%  effects in the environment. This example mainly focus on sound rewards
%  but it can be adapted for other sensory modalities or more complex
%  effects (lights, odors, etc...) 
% 
%   Usage : RTMocap_reward(style,value,audio)
% 
%   STYLE, 1:Artificial 2:Engaging sound, see: RTMocap_design function
%   VALUE, Positive or Negative, 0 indicate the end of the block
%   AUDIO, The preloaded audio structure containing audio files
%
%   Example
%   RTMocap_reward(2,1,audio);
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

function RTMocap_reward(style,value,audio)

    % same call for artifical or engaging sounds
    % see construction of 'audio' structure in RTMocap_audioinit    
	if value > 0
         play(audio(style,1).internalObj);
	elseif value < 0    
        play(audio(style,2).internalObj);
	else
        play(audio(style,3).internalObj);
	end 
    
end