%% Example of how to use computeDsContour()

% Define a joint probability distribution for wind and wave.
PM = getProbabilisticModel(1);

% Compte an IFORM environmental contour with a return period of 1 year.
stateDuration = 6;
nYears = 1;
alpha = 1 / (nYears * 365.25 * 24 / stateDuration);
[x1Array, x2Array] = computeDsContour(PM, 1/alpha * 100, alpha, 10, 1); 
