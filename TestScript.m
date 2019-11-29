% Test Script
% Matt Conrad
% 4/1/2018
clc; clear all; close all;
%% Test DisplaySegment.m

thresh = .001;
DisplaySegment('./waveforms/kiss1.wav',thresh);
DisplaySegment('./waveforms/kiss3.wav',thresh);

%% Test Wave2Features.m 

[raw_data,Fs] = audioread('./waveforms/love1.wav');
load('StartEndFrames.mat');
data = raw_data(Frames(6).start:Frames(6).end);
N_frame = 512;
N_overlap = 100;
N_coeffs = 50;

[feature_seq,vector_count] = Wave2Features(data,N_frame,N_overlap,N_coeffs);

%% Test InsideParallelogram.m
I = 7;
J = 7;
point = [1,J];

bool = InsideParallelogram(point,I,J);

%% Test SpeechRecognition.m

load('StartEndFrames.mat'); % Load the manually found start and end of the speech segment
files = dir('./waveforms/*.wav'); % Load the wav file data

ref_index = 1; % The index of the reference waveform in "files" struct 
test_index = 3; % The index of the comparison waveform in "files" struct

% Make the filenames for the 2 waveforms of interest
ref_filename = strcat(files(ref_index).folder, "/", files(ref_index).name);
test_filename = strcat(files(test_index).folder, "/", files(test_index).name);

% Read in the waveforms
ref = audioread(ref_filename); 
test = audioread(test_filename);

% Use the manually found start/end points to clip the waveform  
ref_clipped = ref(Frames(ref_index).start:Frames(ref_index).end);
test_clipped = test(Frames(test_index).start:Frames(test_index).end);

% Define the number of points that define the frames
N_frame = 512;
N_overlap = 100;
N_coeffs = 50;

% Calculate the minimum cost between the 2 waveforms and calculate the path
% of that minimum cost
[ D,path ] = SpeechRecognition( ref_clipped, test_clipped, N_frame, N_overlap, N_coeffs );

% Normalize the cost
D_norm = D/size(path,1);

% Plot the path
scatter(path(:,1),path(:,2),'*');
grid on; hold on;
title('Optimal Path');
xlabel('Reference Vector Index');
ylabel('Test Vector Index');