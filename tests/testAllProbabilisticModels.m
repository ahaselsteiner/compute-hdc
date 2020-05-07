% Test all models with HD contours.
for i = 1 : 9
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

% Test the 2D CMA models with IFORM and ISORM contours.
for i = [1 2 3 9]
    % Load a probabilistic model.
    PM = getProbabilisticModel(i);

    % Define an exceedance probability, alpha, based on a return period,
    % nYears.
    nYears = 50;
    n = nYears * 365.25 * 24/3;
    alpha = 1/n;

    % Calculate the highest density contour and plot it.
    figure();
    subplot(1, 2, 1);
    [x1Array, x2Array] = computeIformContour(PM, alpha, 360); 
    plot(x1Array, x2Array);
    title('IFORM contour');
    subplot(1, 2, 2);
    [x1Array, x2Array] = computeIsormContour(PM, alpha, 360); 
    plot(x1Array, x2Array);
    title('ISORM contour');
    sgtitle(['Model ' num2str(i)]);
end
