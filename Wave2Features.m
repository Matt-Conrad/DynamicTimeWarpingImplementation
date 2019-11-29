function [ feature_seq, vector_count ] = Wave2Features( waveform, N_frame, N_overlap, N_coeffs )
%WAVE2FEATURES This function converts a wave segment to feature vectors
%   Params:
%       waveform = Nx1 time signal with N total samples, MUST BE CROPPED
%       N_frame = the number of samples in a frame
%       N_overlap = the number of samples that overlap
%       N_coeffs = the number of coefficients being used from FFT
%   Outputs:
%       feature_seq = an (M x N_coeffs) array where frame features vectors lie along the row
%       vector_count = M, the number of feature vectors

waveform = waveform'; % To make sure FFT only has one row

% Initialize variables/constants to be used in while loop
N = length(waveform);
start_frame = 1;
end_frame = start_frame + (N_frame-1);

% Create feature vector sequence1
feature_seq = zeros(1,N_coeffs);
vector_count = 0;

while ( (N-start_frame) > (N_frame-1) )
    % Take FFT of the current frame
    current_frame = waveform(start_frame:end_frame);
    current_frame_fft = fft(current_frame);
    
    % Append first N_coeffs coefficients to feature vector sequence
    if (vector_count == 0)
        feature_seq = current_frame_fft(1:N_coeffs);
    else
        feature_seq = [feature_seq ; current_frame_fft(1:N_coeffs)];
    end
    vector_count = vector_count + 1;
    
    % Update the frame boundaries
    start_frame = end_frame - (N_overlap - 1);
    end_frame = start_frame + (N_frame-1);
end

end