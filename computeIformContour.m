%% computeIformContour
% Returns the coordinates of an IFORM environmental contour.
% The implementation works only for two-dimensional models.
%
%% Function input parameters
%
% _ProbModel_: joint probability model array. One model for each
% variable, a model has: .distribution, .isConditional and .coeff
%
% _alpha_: exceeedance probability, default = 1 / (50 * 365.25 * 24)
%
% _nAngles_: number of angles in U-space to be evaluated, default = 36
%
% _shouldPlot_: if 1 results are plotted, default = 0
%
% _shouldPlotAngleLabels_: if 1 angleArray nunbers are plotted, 
% default = 0
%
%% Function output parameters
%
% _x1Array_: x coordinates of the points along the contour
%
% _x2Array_: y coordinates of the points along th econtour
%
%% Example
% Define a joint probability distribution (proposed by Vanem and Bitner-
% Gregersen, 2012):
%
% PM.name = 'Vanem and Bitner-Gregersen (2012)';
% PM.modelType = 'CMA';
% PM.distributions = {'weibull'; 'lognormal'};
% PM.isConditionals = {[0 0 0]; [1 1]};
% PM.coeffs = {{2.776 1.471 0.8888}; 
%              { @(x1)0.1000 + 1.489 * x1^0.1901;
%                @(x1)0.0400 + 0.1748 * exp(-0.2243*x1)}
%              };
% PM.labels = {'Significant wave height (m)';
%              'Zero-upcrossing period (s)'};
% PM.gridCenterPoints = {0:0.1:20; 0:0.1:18};
%
% Either use the default parameters: 
%
%   [x1Array, x2Array] = computeIformContour(PM); 
%
% Or use custom parameters and plot the contour in U- and X-space:
%
%   computeIformContour(PM, 4, 15, 1);
%
%% Theoretical background
%
% IFORM (inverse first-order reliability method) contours were first
% proposed by Winterstein et al. (1993).
% The method is well established and recommended, for example, by 
% the offshore wind turbien standard IEC 61300-3-1.
%
% IFORM contours are defined in standard normal variables.
% Therefore the Rosenblatt transformation (Rosenblatt, 1952) is used.
%
%% License & repository
% https://github.com/ahaselsteiner/compute-hdc

function [x1Array, x2Array] = computeIformContour(PM, alpha, ...
    nAngles, shouldPlot)

% --- check input parameters ---
if ~exist('alpha', 'var')
    alpha = 1 / (50 * 365.25 * 24); % = 50 yrs if the state duration is 1 hr.
end
if ~exist('nAngles', 'var')
    nAngles = 36;
end
if ~exist('shouldPlot', 'var')
    shouldPlot = 0;
end
if ~strcmp(PM.modelType, 'CMA')
    disp('Stopping computeIformContour as the input model is not of type CMA');
    x1Array = nan(1);
    x2Array = nan(1);
    return
end


% --- define constants ---
ANGLE_TEXT_DIST = 0.5;


% --- compute ---
angleStep = 360/nAngles;
angleArray = [0:angleStep:360-angleStep];

beta = icdf('normal', 1 - alpha, 0, 1);
u1Array = beta * cos(angleArray/180*pi);
u2Array = beta * sin(angleArray/180*pi);

probabilityU1Array = cdf('normal', u1Array, 0, 1);
probabilityU2Array = cdf('normal', u2Array, 0, 1);

switch PM.distributions{1}
    case 'weibull'
        x1Array = icdf(PM.distributions{1}, probabilityU1Array, ...
            PM.coeffs{1}{1}, PM.coeffs{1}{2})...
            + PM.coeffs{1}{3}; % this is specific for the 3 parameter Weibull distribution, if only two parameters are given, parameter 3 = 0
    case 'exponentiated-weibull'
        dist = ExponentiatedWeibull(PM.coeffs{1}{1}, PM.coeffs{1}{2}, ...
            + PM.coeffs{1}{3});
        x1Array = dist.icdf(probabilityU1Array);
    otherwise
        x1Array = icdf(PM.distributions{1}, probabilityU1Array, ...
            PM.coeffs{1}{1}, PM.coeffs{1}{2});
end
            
x2Array = zeros(1, length(x1Array));
for i = 1:length(x1Array)
    coeffs = cell(length(PM.coeffs{2}), 1);
    for j = 1 : length(PM.coeffs{2})
        if PM.isConditionals{2}(j)
            coeffs{j} = PM.coeffs{2}{j}(x1Array(i));
        else
            coeffs{j} = PM.coeffs{2}{j};
        end
    end
    switch PM.distributions{2}
        case 'weibull'
            x2Array(i) = icdf(PM.distributions{2}, probabilityU2Array(i), ...
                PM.coeffs{2}{1}(x1Array(i)), PM.coeffs{2}{2}(x1Array(i))) ...
                + PM.coeffs{2}{3}; % this is specific for the 3 parameter Weibull distribution, if only two parameters are given, parameter 3 = 0
        case 'lognormnormmixture'
            cdf_lognormnormmixture = @(x, p, mulog, sigmalog, munorm, sigmanorm) ...
                p*logncdf(x, mulog, sigmalog) + (1-p)*normcdf(x,munorm,sigmanorm);
            invcdf_lognormnormmixture = @(y, p, mulog, sigmalog, munorm, sigmanorm)...
                fzero(@(x) cdf_lognormnormmixture(x, p, mulog, sigmalog, ...
                munorm, sigmanorm) - y, 0);
            x2Array(i) = invcdf_lognormnormmixture(probabilityU2Array(i), ...
                PM.coeffs{2}{1}(x1Array(i)), ...
                PM.coeffs{2}{2}(x1Array(i)), PM.coeffs{2}{3}(x1Array(i)), ...
                PM.coeffs{2}{4}, PM.coeffs{2}{5});
        case 'exponentiated-weibull'
            dist = ExponentiatedWeibull(coeffs{1}, coeffs{2}, coeffs{3});
            x2Array(i) = dist.icdf(probabilityU2Array(i));
        otherwise
            x2Array(i) = icdf(PM.distributions{2}, probabilityU2Array(i), ...
                coeffs{1}, coeffs{2});
    end
end

% --- plot ---
if (shouldPlot == 1)
    figure    
    plot([x1Array x1Array(1)], [x2Array x2Array(1)], '-k')
    xlabel(PM.labels{1});
    ylabel(PM.labels{2});
end