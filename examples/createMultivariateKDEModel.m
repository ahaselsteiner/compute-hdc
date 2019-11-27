% Load some sample data.
load hald
observations = ingredients(:, 1:3);

% Define the points where the density should be estimated.
x = -20:2:40;
y = -20:4:110;
z = -10:2:45;
[yy, xx, zz] = meshgrid(y,x,z);
points = [xx(:), yy(:), zz(:)];

% Estimate the density and distribution.
bandWidth = std(observations) / 2;
f = mvksdensity(observations,points,'Bandwidth',bandWidth);
F = mvksdensity(observations,points,'Bandwidth',bandWidth, ...
    'Function', 'cdf');

% Reshape the density and distribution into a 3-dimensional array.
ff = reshape(f, [length(x), length(y), length(z)]);
FF = reshape(F, [length(x), length(y), length(z)]);

ProbModelKDE3d.name = 'kernel density estimation 3D';
ProbModelKDE3d.modelType = 'KDE';
ProbModelKDE3d.cdf = FF;
ProbModelKDE3d.pdf = ff;
ProbModelKDE3d.cdfGrid = {xx; yy; zz};
ProbModelKDE3d.labels = {'x1 (-)'; 'x2 (-)'; 'x3 (-)'};
ProbModelKDE3d.gridCenterPoints = {x + abs(x(1) - x(2))/2;
                                   y + abs(y(1) - y(2))/2
                                   z + abs(z(1) - z(2))/2};
                               
% Define an exceedance probability, alpha, based on a return period, nYears
nYears = 50;
n = nYears * 365.25 * 24/3;
alpha = 1/n;

% Calculate the highest density contour and plot it.
[fm, x1Hdc, x2Hdc, x3Hdc, x4Hdc] = computeHdc(ProbModelKDE3d, alpha, ...
    ProbModelKDE3d.gridCenterPoints, 1);
hold on
scatter3(observations(:,1), observations(:,2), observations(:,3), ...
    'ob', 'linewidth', 4)
