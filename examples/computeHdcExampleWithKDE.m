% Load a probabilistic model, which was created using kernel density
% estimation:
ProbModel = getProbabilisticModel(7);

% Define an exceedance probability, alpha, based on a return period, nYears
nYears = 50;
n = nYears * 365.25 * 24/3;
alpha = 1/n;

% Define the grid center points for the numerical integration (each ...
% cell represents one dimension)
gridCenterPoints = {0:0.1:20 0:0.1:18};

% Calculate the highest density contour and plot it
[fm, x1Hdc, x2Hdc] = computeHdc(ProbModel, alpha, gridCenterPoints, 1);
