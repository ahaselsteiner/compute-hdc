% Load some sample data.
load hald
observations = ingredients(:, 1:3) ;

% Define the points where the density should be estimated.
x = 0:1:30;
y = 0:4:120;
z = 0:1:35;
[xx, yy, zz] = meshgrid(x,y,z);
points = [xx(:), yy(:), zz(:)];

% Estimate the density and distribution.
bandWidth = [2 4 2];
f = mvksdensity(observations,points,'Bandwidth',bandWidth);
F = mvksdensity(observations,points,'Bandwidth',bandWidth, 'Function', 'cdf');

% Reshape the density and distribution into a 3-dimensional array.
ff = reshape(f, [length(x), length(y), length(z)]);
FF = reshape(F, [length(x), length(y), length(z)]);

ProbModelKDE3d.name = 'kernel density estimation 2d';
ProbModelKDE3d.modelType = 'KDE';
ProbModelKDE3d.cdf = FF;
ProbModelKDE3d.pdf = ff;
ProbModelKDE3d.cdfGrid = {xx, yy, zz};
ProbModelKDE3d.labels = {'x1 (-)', 'x2 (-)', 'x3 (-)'};
ProbModelKDE3d.gridCenterPoints = {x + abs(x(1) - x(2))/2;
                                   y + abs(y(1) - y(2))/2
                                   z + abs(z(1) - z(2))/2};
                               

alpha = 0.1 ;

% Define the grid center points for the numerical integration (each ...
% cell represents one dimension).
gridCenterPoints = ProbModelKDE3d.gridCenterPoints;

% Calculate the highest density contour and plot it.
[fm, x1Hdc, x2Hdc, x3Hdc, x4Hdc] = computeHdc(ProbModelKDE3d, alpha, gridCenterPoints, 1);
                               