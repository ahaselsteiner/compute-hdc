%% Example of how to use computeIsormContour()

% Define a joint probability distribution for wind and wave (model was 
% proposed in "Global hierarchical models for wind and wave contours").
PM = getProbabilisticModel(9);

% Compte an IFORM environmental contour with a return period of 50 years.
stateDuration = 1;
nYears = 50;
alpha = 1 / (nYears * 365.25 * 24 / stateDuration);
[x1Array, x2Array] = computeIsormContour(PM, alpha, 360, 1); 
