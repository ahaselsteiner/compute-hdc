%% Examples of how to use computeHdc()
%
% This highest density contour (HDC) implementation works up to 4
% dimensions.
%
% The function getEnvironmentalPdfModel() provides some sample probability
% density models.

%% Example 1: 2-dimensional contour

% Define a joint probability distribution (taken from Vanemn and Bitner-
% Gregersen, 2012):
ModelArray = getProbabilisticModel(1);

% Define an exceedance probability, alpha, based on a return period, nYears
nYears = 50;
n = nYears * 365.25 * 24/3;
alpha = 1/n;

% Define the grid center points for the numerical integration (each ...
% cell represents one dimension)
gridCenterPoints = {0:0.1:20 0:0.1:18};

% Calculate the highest density contour and plot it
[fm, x1Hdc, x2Hdc, x3Hdc, x4Hdc] = computeHdc(ModelArray, alpha, ...
    gridCenterPoints, 1);

%% Example 2: 3-dimensional "contour" (surface)

% Define a 3-dimensional joint probability distribution and a grid
ModelArray = getProbabilisticModel(4);
gridCenterPoints = ModelArray.gridCenterPoints;

% Calculate the highest density contour and plot it
[fm, x1Hdc, x2Hdc, x3Hdc, x4Hdc] = computeHdc(ModelArray, alpha, ...
    gridCenterPoints, 1);

%% Author: Andras F. Haselsteiner
