function [ bool ] = InsideParallelogram( point,I,J )
%INSIDEPARALLELOGRAM This function checks to see whether the point under
%consideration is in Itakura's parallelogram
%   Params:
%       point = the 1x2 point under consideration
%       I = the number of frames in the reference pattern
%       J = the number of frames in the test pattern
%   Outputs:
%       bool = the verdict on whether the point is in the parallelogram

bool = 0;

left_steep = @(j) (j+1)/2;
left_flat = @(i) .5*i+(J-.5*I);
right_steep = @(j) (j-J+2*I)/2;
right_flat = @(i) .5*i+.5;

upper_j = left_flat(point(1));
lower_j = right_flat(point(1));
if ( (point(2) <= upper_j) && (point(2) >= lower_j) ) % if inside flats
    left_i = left_steep(point(2));
    right_i = right_steep(point(2));
    if ( (point(1) <= right_i) && (point(1) >= left_i) )
        bool = 1;
    end
end

end