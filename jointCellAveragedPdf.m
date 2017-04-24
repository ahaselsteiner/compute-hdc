function fbarjoint = jointCellAveragedPdf(ModelArray, gridCenterPoints)
%JOINTCELLAVERARAGEDPDF returns the cell-averaged joint probability density
%   ModelArray  model vector, one model for each variable, a model has:
%           .distribution, .isConditional, .coeff and .label
%   gridCenterPoints       grid center locations; formatted as cell,
%                          thus gridCenterPoints{1} contains the vector
%                          for the first variable / dimension
%
%   Currently supports up to 4 dimensions

p = length(ModelArray); % number of dimensions

if p>4
    disp('Error: Only up to 4 dimensions are supported')
    return
end

sizeGridCenterPoints = zeros(length(gridCenterPoints), 1);
for i = 1:length(gridCenterPoints)
  sizeGridCenterPoints(i) = length(gridCenterPoints{i});
end

% --- dimension 1 ---
fbarxj{1} = marginalCellAveragedPdf(ModelArray(1), gridCenterPoints{1}');
fbarxj{1} = repmat(fbarxj{1}, [1 sizeGridCenterPoints(2:end)']);

% --- dimension 2 ---
for i = 1:length(gridCenterPoints{1}) 
    fbarxj{2}(i,:) = marginalCellAveragedPdf(ModelArray(2), ...
        gridCenterPoints{2}', gridCenterPoints{1}(i));
end
if (p>=3)
    fbarxj{2} = repmat(fbarxj{2}, [1 1 sizeGridCenterPoints(3:end)']);
end

% --- dimension 3 ---
if (p>=3)
    for i = 1:length(gridCenterPoints{1})
        for j = 1:length(gridCenterPoints{2}) 
            fbarxj{3}(i,j,:) = marginalCellAveragedPdf(ModelArray(3), ...
                gridCenterPoints{3}', [gridCenterPoints{1}(i); ...
                gridCenterPoints{2}(j)]);
        end
    end
end
if (p>=4)
    fbarxj{3} = repmat(fbarxj{3}, [1 1 1 sizeGridCenterPoints(4:end)']);
end

% --- dimension 4 ---
if (p>=4)
    for i = 1:length(gridCenterPoints{1})
        for j = 1:length(gridCenterPoints{2}) 
            for k = 1:length(gridCenterPoints{3}) 
                fbarxj{4}(i,j,k,:) = marginalCellAveragedPdf(ModelArray(4), ...
                    gridCenterPoints{4}', [gridCenterPoints{1}(i); ...
                    gridCenterPoints{2}(j); gridCenterPoints{3}(k)]);
            end
        end
    end
end

fbarjoint = ones(sizeGridCenterPoints');
for i = 1:length(gridCenterPoints)
    fbarjoint = fbarjoint .* fbarxj{i};
end

% Author: Andras F. Haselsteiner, December 23, 2016
