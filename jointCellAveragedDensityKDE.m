function fbarjoint = jointCellAveragedDensityKDE(PM)
%JOINTCELLAVERAGEDDENSITYKDE returns the cell-averaged joint probability 
%density
%   PM                     probabilistic model of type 'KDE'
%
%   Note: The grid center points (PM.gridCenterPoints) must be in centers 
%   of the grid cells used to evaluate the KDE (PM.cdfGrid). Consequently, 
%   gridCenterPoints are a required field of the probabilistic model and 
%   cannot be changed without changing the model's "cdf" and "cdfGrid" 
%   fields.
%
%   Supports probabilistic model with up to 3 dimensions.

gridCenterPoints = PM.gridCenterPoints;

p = length(PM.labels);


F = PM.cdf;
cellSize = 1;
dx = zeros(p,1);
for i = 1:p
    dx(i) = gridCenterPoints{i}(2) - gridCenterPoints{i}(1);
    cellSize = cellSize * dx(i);
end


fbarjoint = zeros(size(PM.pdf)-1);
if p==2
    for i=1:size(PM.pdf,1)-1
        for j=1:size(PM.pdf,2)-1
            fbarjoint(i,j) = (F(i+1,j+1) - F(i,j+1) - F(i+1,j) + F(i,j)) ...
                / cellSize;
           if fbarjoint(i,j) < 0
               msg = ['Value for fbarjoint is < 0.' ...
                   ' fbarjoint(' num2str(i) ',' num2str(j) ') = ' ...
                   num2str(fbarjoint(i,j))];
               warning(msg);
           end
        end
    end
elseif p==3
    for i=1:size(PM.pdf,1)-1
        for j=1:size(PM.pdf,2)-1
            for k=1:size(PM.pdf,3)-1
                fbarjoint(i,j,k) = ...
                    (F(i+1, j+1, k+1) ...
                     - F(i+1, j+1, k) ...
                     - F(i+1 ,j, k+1) ...
                     - F(i, j+1, k+1) ...
                     + F(i+1, j, k) ...
                     + F(i, j+1, k) ...
                     + F(i, j, k+1) ...
                     - F(i,j,k) ...
                    ) ...
                   / cellSize;
               
               if fbarjoint(i,j,k) < 0
                   msg = ['Value for fbarjoint is < 0.' ...
                       ' fbarjoint(' num2str(i) ',' num2str(j), ',' ...
                       num2str(k) ') = ' num2str(fbarjoint(i,j,k))];
                   warning(msg);
               end
            end
        end
    end
else
    msg = 'Currently only up to 3-dimensional models are supported.';
    error(msg);
end
