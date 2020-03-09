function [xcont, ycont] = computeDsContour(PM, n, alpha, dtdeg, doPlot)
% COMPUTEDSCONTOUR computes a direct sampling contour.
%   Inputs:
%   PM - Probabilistic model defined int he strucutre shown in
%   getProbabilisticModel.m
%   n - Number of observations to simulate.
%   alpha - Exceedance probability of the contour.
%   dtdeg - Directional step in degrees.
%   doPlot - If true the contour is plotted.

% Check inputs.
if ~exist('dtdeg', 'var')
    nAngles = 10;
end
if ~exist('doPlot', 'var')
    doPlot = 0;
end
p = length(PM.distributions); % Number of dimensions.
if p>2
    disp('Error: Only 2 dimensions are supported.')
    return
end

% Initialize.
x = nan(n, 1);
y = nan(n, 1);

switch PM.distributions{1}
    case 'weibull'
        d1 = TranslatedWeibull(PM.coeffs{1}{1}, PM.coeffs{1}{2}, PM.coeffs{1}{3});
        x = d1.drawSample(n);
    case 'exponentiated-weibull'
        d1 = ExponentiatedWeibull(PM.coeffs{1}{1}, PM.coeffs{1}{2}, PM.coeffs{1}{3});
        x = d1.drawSample(n);
    case 'lognormal'
        mu = PM.coeffs{1}{1};
        sigma = PM.coeffs{1}{2};
        x = lognrnd(mu, sigma, n, 1);
    otherwise
        disp(['Error: Distribution '  PM.distributions{1} ' is not supported.'])
        return
end
switch PM.distributions{2}
    case 'weibull'
        for i = 1: n
            d2 = TranslatedWeibull(PM.coeffs{2}{1}(x(i)), ...
                PM.coeffs{2}{2}(x(i)), ...
                PM.coeffs{2}{3}(x(i)));
            y(i) = d2.drawSample(1);
        end
    case 'exponentiated-weibull'
        for i = 1: n
            d2 = ExponentiatedWeibull(PM.coeffs{2}{1}(x(i)), ...
                PM.coeffs{2}{2}(x(i)), ...
                PM.coeffs{2}{3}(x(i)));
            y(i) = d2.drawSample(1);
        end
    case 'lognormal'
        mu = PM.coeffs{2}{1}(x);
        sigma = PM.coeffs{2}{2}(x);
        y = lognrnd(mu, sigma, n, 1);
    otherwise 
        disp(['Error: Distribution '  PM.distributions{2} ' is not supported.'])
        return
end

[xcont, ycont] = dsContour2D(x, y, alpha, dtdeg);

if doPlot == 1
    figure();
    plot(x, y, '.k');
    hold on
    plot(xcont, ycont, '-b', 'linewidth', 2);
    xlabel(PM.labels{1});
    ylabel(PM.labels{2});
end

end

function [xcont, ycont] = dsContour2D(x, y, alpha, dtdeg)
% DSCONTOUR2D calculates a 2D direct sampling contour.
%   Inputs:
%   x,y - Sample of data.
%   alpha - Exceedance probability of the contour.
%   dtdeg - Directional step in degrees.

% Initialisation.
dt = dtdeg * pi / 180;
t = (dt : dt : 2 * pi)';
Nx = length(x);
Nt = length(t);
Np = length(alpha);
r = zeros(Nt, Np);
xcont = zeros(Nt, Np);
ycont = zeros(Nt, Np);

% Find radius for each angle.
for i = 1 : length(t)
    if Nx > 1e6
        fprintf('   angle %u/%u\n',i,Nt)
    end
    z = x * cos(t(i)) + y * sin(t(i));
    r(i, :) = quantile(z, 1 - alpha);
end

% Find intersection of lines.
t = [t;dt];
r = [r;r(1,:)];
denominator = sin(t(2:end)).*cos(t(1:end-1)) - sin(t(1:end-1)).*cos(t(2:end));
for j = 1 : Np
    xcont(:,j) = (sin(t(2 : end)) .* r(1 : end - 1, j) - sin(t(1 : end - 1)) .* r(2 : end, j)) ./ denominator;
    ycont(:,j) = (-cos(t(2 : end)) .* r(1 : end - 1, j) + cos(t(1 : end - 1)) .* r(2 : end, j)) ./ denominator;
end
end