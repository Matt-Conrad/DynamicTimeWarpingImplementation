function [ ] = DisplaySegment( filename, thresh )
%DISPLAYSEGMENT Displays the given segment
%   Params:
%       filename = string of the filename with extension
%       thresh = the threshold that determines start and end frames

% Read the waveform in
[data,Fs] = audioread(filename);
N = length(data); % Number of samples

% Calculate the time axis
Ts = 1/Fs;
last_stamp = (N-1)*Ts;
t = 0:Ts:last_stamp; % Time frame starts at 0, not Ts

% Display the information
figure;
plot(t,data); 

end
