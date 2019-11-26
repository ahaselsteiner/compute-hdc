%% computeHdc
% Computes a highest density contour for a given exceedance probability.
% Currently works for probability density functions with up to 4 dimensions.
%
%% Function input parameters
%
% _ProbModel_: probabilistic model, see getProbabilisticModel()
% to see which fields the struct has, default = an example pdf is shown
%
% _alpha_: exceedance probability, default = 6.8e-6 (corresponds to a return 
% period of 50 years with 3 hours sea states)
%
% _gridCenterPoints_: center points of the grid cells (the numeric 
% integration scheme works on an orthogonal grid); formatted as cell,
% thus gridCenterPoints{1} contains the vector for the first variable 
% / dimension; default = the _ProbModel_ .gridCenterPoints field is used
%
% _shouldPlot_: if 1 the contour is plotted, default = 0
%
%% Function output parameters
% _fm_: minimum probability density of the enclosed region / probability
% density along the contour
%
% _x1Hdc_: x1 coordinates of the points along the contour, since there
% can be multiple enclosed contiguous regions the output is a cell array
% with each element representing one connected boundary
%
% _x2Hdc_: x2 coordinates of the points along the contour
%
% _x3Hdc_: x3 coordinates of the points along the contour
%
% _x4Hdc_: x4 coordinates of the points along the contour
%
%% Theoretical background
%
% Highest density contours (HDC) enclose highest density regions (HDR)
% and have been proposed in the publication "Deriving environmental 
% contours from highest density regions" by Haselsteiner, Ohlendorf,
% Wosnoik, Thoben (http://doi.org/10.1016/j.coastaleng.2017.03.002). This
% Matlab implementation has been developed with the publication.


function [fm, x1Hdc, x2Hdc, x3Hdc, x4Hdc] = computeHdc(PM, alpha, ...
    gridCenterPoints, shouldPlot)

% --- check required software (Matlab + toolboxes / Octave + packages ) ---
isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0; % thanks to: http://stackoverflow.com/questions/2246579/how-do-i-detect-if-im-running-matlab-or-octave
if isOctave % load the required packages
    pkg load image
    pkg load statistics
else
    hasAllToolboxes = license('test', 'image_toolbox') && ...
        license('test', 'statistics_toolbox');
    if ~hasAllToolboxes
        msg = ['Error. computeHdc requires the image and statistics ' ...
            'toolbox. Exiting.'];
        error(msg)
    end    
end

% --- validate input parameters ---
if ~exist('PM', 'var')
    disp('Warning: No probabilistic model, "PM", has been entered. Showing example.');
    PM = getProbabilisticModel(1);
    shouldPlot = 1;
end
if ~exist('alpha', 'var')
    alpha = 1/(50*365.25*24/3); % 50 years with 3 hour environmental states
end
if ~exist('gridCenterPoints', 'var')
    gridCenterPoints = PM.gridCenterPoints;
else
    if PM.modelType == 'KDE'
        msg = ['Overwriting your input gridCenterPoints to ' ...
            'PM.gridCenterPoints because gridCenterPoints must be aligned ' ...
            'with PM.cdf and PM.cdfGrid'];
        warning(msg);
        gridCenterPoints = PM.gridCenterPoints;
    end
end
if ~exist('shouldPlot', 'var')
    shouldPlot = 0;
end

% --- calculate needed input variables ---
p = length(gridCenterPoints); % number of dimensions
dx = zeros(p, 1);
cellSize = 1;
for i = 1:p
    dx(i) = gridCenterPoints{i}(2) - gridCenterPoints{i}(1);
    cellSize = cellSize * dx(i);
end

% --- compute hdc ---
fbarjoint = jointCellAveragedDensity(PM, gridCenterPoints);
Fbarzero = @(fm)probabilityOfHdr(fbarjoint, fm, cellSize) - 1 + alpha;
fm = fzero(Fbarzero, 0);
hdrBinary = fbarjoint >= fm;
[x1Hdc, x2Hdc, x3Hdc, x4Hdc] = computeHdrBoundary(hdrBinary, gridCenterPoints);

% --- plot ---
if shouldPlot
    plotHdc(PM, alpha, gridCenterPoints, fbarjoint, hdrBinary, ...
        x1Hdc, x2Hdc, x3Hdc, x4Hdc);
end
