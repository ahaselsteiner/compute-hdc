function [x1Hdc, x2Hdc, x3Hdc, x4Hdc] = computeHdrBoundary(hdrBinary, gridCenterPoints)
%COMPUTEHDRBOUNDARY computes the boundary of the highest density region
%   hdrBinary       p-dimensional binary array, 1 = part of HDR
%   gridCenterPoints       grid center locations; formatted as cell,
%                          thus gridCenterPoints{1} contains the vector
%                          for the first variable / dimension 

% default values for output
x1Hdc = cell(1); x2Hdc = cell(1); x3Hdc = cell(1); x4Hdc = cell(1);

% validate input
if ~exist('hdrBinary', 'var') || ~exist('gridCenterPoints', 'var')
    disp(['Error: computeHdrBoundary needs input for both hdrBinary and '...
    'gridCenterPoints. Exiting.']);
    return
end

p = ndims(hdrBinary); % number of dimensions

if p>4
    disp(['Warning: Too many dimensions. Only up to 4 dimensions are ' ...
        'supported. Exiting.'])
    return
end

if p == 2
    [B, C] = bwboundaries(hdrBinary);
    for i = 1:length(B)
        x1Hdc{i} = gridCenterPoints{1}(B{i}(:,1))';
        x2Hdc{i} = gridCenterPoints{2}(B{i}(:,2))';
    end
else
    structuring_element = true(zeros(1,p)+3); % for image erosion algorithm
    if p == 3  
        surfaceVoxels = hdrBinary - imerode(hdrBinary, structuring_element);
        surfaceVoxelsIndices=find(surfaceVoxels);
        [i1,i2,i3] = ind2sub(size(surfaceVoxels),surfaceVoxelsIndices);
        x1Hdc{1} = gridCenterPoints{1}(i1);
        x2Hdc{1} = gridCenterPoints{2}(i2);    
        x3Hdc{1} = gridCenterPoints{3}(i3);  
    else
        if p==4
            boundaryPoints = hdrBinary - imerode(hdrBinary, structuring_element);
            boundaryPointsIndices=find(boundaryPoints);
            [i1,i2,i3,i4] = ind2sub(size(boundaryPoints),boundaryPointsIndices);
            x1Hdc{1} = gridCenterPoints{1}(i1);
            x2Hdc{1} = gridCenterPoints{2}(i2);    
            x3Hdc{1} = gridCenterPoints{3}(i3); 
            x4Hdc{1} = gridCenterPoints{4}(i4);  
        end
    end
end
end

% code by Andras F. Haselsteiner, November 7, 2017
