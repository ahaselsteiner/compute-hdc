for i =1:7
    % Load a probabilistic model.
    ProbModel = getProbabilisticModel(i);

    % Define an exceedance probability, alpha, based on a return period,
    % nYears.
    nYears = 50;
    n = nYears * 365.25 * 24/3;
    alpha = 1/n;

    % Define the grid center points for the numerical integration (each ...
    % cell represents one dimension).
    gridCenterPoints = ProbModel.gridCenterPoints;

    % Calculate the highest density contour and plot it.
    [fm, x1Hdc, x2Hdc, x3Hdc, x4Hdc] = computeHdc(ProbModel, alpha, gridCenterPoints, 1);
end
