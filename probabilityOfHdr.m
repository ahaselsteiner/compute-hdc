function [Fbar] = probabilityOfHdr( fbarjoint, fm, cellSize )
%PROBABILITYOFHDR comptues the probability associated with a HDR
%   fbarjoint   n-dimensional Array containing the probability density
%               values
%   fm          treshold for f >= fm (minimum probability density)

R = fbarjoint(fbarjoint >= fm);
cellProbability = R * cellSize;
Fbar = sum(cellProbability(:));

end

% Author: Andras F. Haselsteiner