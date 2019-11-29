function [ D,path ] = SpeechRecognition( ref, test, N_frame, N_overlap, N_coeffs )
%SPEECHRECOGNITION This function calculates the minimum cost between two
%waveforms (a test and reference) using Dynamic Time Warping 
%   Params:
%       ref = reference waveform MUST BE CROPPED
%       test = test waveform MUST BE CROPPED
%       N_frame = the number of samples in a frame
%       N_overlap = the number of samples that overlap
%       N_coeffs = the number of coefficients being used from FFT
%   Outputs:
%       D = minimum cost between 2 waveforms
%       path = the path coordinates

% Convert the waveform to feature vector sequences
[ref_seq,I] = Wave2Features(ref,N_frame,N_overlap,N_coeffs);
[test_seq,J] = Wave2Features(test,N_frame,N_overlap,N_coeffs);

% Assume we are starting at (1,1) like the book says
current_x = 1;
current_y = 1;

% Calculate the cost of the first node
ref_feat_vec = ref_seq(current_x,1:N_coeffs);
test_feat_vec = test_seq(current_y,1:N_coeffs);
% D = abs(sqrt(sum((ref_feat_vec - test_feat_vec).^2))); % Cost is the magnitude of Euclidean here
diff_vec = ref_feat_vec - test_feat_vec;
D = sqrt(dot(diff_vec,diff_vec));

prev_horizontal = 0; % flag; false/0 means that the previous transition was a horizontal
path = [1,1]; % Been to the first node

while ( (current_x ~= I) && (current_y ~= J) ) % while we're not at (I,J)
    % Determine the points that we can jump to based on whether the last
    % hop was horizontal or not
    if (~prev_horizontal)
        potential_pts = [ (current_x+1),current_y ; (current_x+1),(current_y+1) ; ...
            (current_x+1),(current_y+2)];
    else
        potential_pts = [ (current_x+1),(current_y+1) ; (current_x+1),(current_y+2) ];
    end
    num_potential_pts = size(potential_pts,1);
    
    % Check if these points are in the parallelogram
    valid_count = 0;
    for i = 1:num_potential_pts
        pot_pt = potential_pts(i,1:2);

        if (InsideParallelogram(pot_pt,I,J))
            valid_count = valid_count + 1;
            cost_pts(valid_count,1:2) = pot_pt; % Mark valid if in parallelogram
        end
    end
    
    % Calculate the cost for each valid point
    cost = inf*ones(valid_count,1);
    for i = 1:valid_count 
        ref_feat_vec = ref_seq(cost_pts(i,1),1:N_coeffs); 
        test_feat_vec = test_seq(cost_pts(i,2),1:N_coeffs);
        
        diff_vec = ref_feat_vec - test_feat_vec;
        cost(i,1) = sqrt(dot(diff_vec,diff_vec));
    end
    
    % Calculate the minimum cost
    min_cost = min(cost);
    min_cost_index = find(cost==min_cost);
    
    % Update loop parameters
    D = D + min_cost;
    path((current_x+1),1:2) = cost_pts(min_cost_index,1:2); % The (i,j) with the min cost is next in path
    
    if (prev_horizontal) % If the previous one was horizontal, then we forced it to a diagonal 
        prev_horizontal = 0; % meaning we can reset the flag
    end
    % If the option for horizontal is there and next jump in the path has
    % the same j, then we clearly jumped horizontally and must set the flag
    if ( (num_potential_pts == 3) && (path((current_x+1),2) == current_y) )
        prev_horizontal = 1;
    end
    
    current_y = path((current_x+1),2);
    current_x = path((current_x+1),1);
end

end