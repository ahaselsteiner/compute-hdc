for i =1:8
    % Load a probabilistic model.
    PM = getProbabilisticModel(i);

    % Define an exceedance probability, alpha, based on a return period,
    % nYears.
    nYears = 50;
    n = nYears * 365.25 * 24/3;
    alpha = 1/n;

    % Calculate the highest density contour and plot it.
    [fm, x1Hdc, x2Hdc, x3Hdc, x4Hdc] = computeHdc(PM, alpha, PM.gridCenterPoints, 1);
end
