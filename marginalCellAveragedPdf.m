function fbar = marginalCellAveragedPdf(Model, x, lowerDimensionalXArray)
%MARGINALCELLAVERAGEDPDF return the marginal probability density of the given Model
%   Model           struct containing:
%                       .distribution - string, e.g. 'weibull', 'lognormal'
%                       .isConditional - boolean array for each parameter, e.g. [1 1 1]
%                       .coeff - double array or function array, e.g. [2.3, 1.7, 0.2]
%   x               vector where distribution should be evaluated, these
%                   are the cell centers, dx must be constant
%   lowerDimensionalXArray    vector with values for xn-2, xn-1 (e.g. ...
%                             [2.3 1]) or scalar for xn-1, e.g. 2.3
%
% Currently supports conditionality on up to three variables (and thus 4 
% dimensional models)
%
% Supported pdfs: 
%   - standard matlab pdf models (e.g. "normal", "lognormal")
%   - "weibull"     2 and 3 parameter pdfs (3rd parameter is set to 0 if 2
%                   parameter model is being be used)
%   - "lognormnormmixture"
%                   mixture model combining a log-normal and normal pdf
dx = x(2)-x(1);

pdfCoeff = zeros(5,1); % setting all parameters to zero, --> Weibull [x1 x2] will become Weibull [x1 x2 0]
for i = 1:length(Model.coeff)
    if Model.isConditional(i)
        switch length(lowerDimensionalXArray)
            case 1
                pdfCoeff(i) = Model.coeff{i}(lowerDimensionalXArray);
            case 2
                pdfCoeff(i) = Model.coeff{i}(lowerDimensionalXArray(1), ...
                    lowerDimensionalXArray(2));
            case 3
                pdfCoeff(i) = Model.coeff{i}(lowerDimensionalXArray(1), ...
                    lowerDimensionalXArray(2), lowerDimensionalXArray(3));
        end        
    else
        pdfCoeff(i) = Model.coeff{i};
    end
end
            
switch Model.distribution
    case 'weibull' 
        Fhigh = wblcdf(x+0.5*dx - pdfCoeff(3), pdfCoeff(1), pdfCoeff(2));
        Flow = wblcdf(x-0.5*dx - pdfCoeff(3), pdfCoeff(1), pdfCoeff(2));
    case 'lognormnormmixture' % for theory see: http://ww2.valdosta.edu/~jwang/paper/MixNormal.pdf
        cdf_lognormnormmixture = @(x,p,mulog,sigmalog, munorm, sigmanorm) ...
            p*logncdf(x, mulog, sigmalog) + (1-p)*normcdf(x,munorm,sigmanorm);
        Fhigh = cdf_lognormnormmixture(x+0.5*dx, pdfCoeff(1), ...
            pdfCoeff(2), pdfCoeff(3), pdfCoeff(4), pdfCoeff(5));
        Flow = cdf_lognormnormmixture(x-0.5*dx, pdfCoeff(1), ...
            pdfCoeff(2), pdfCoeff(3), pdfCoeff(4), pdfCoeff(5));
    otherwise % covers e.g. "normal" and "lognormal"
        Fhigh = cdf(Model.distribution, x+0.5*dx, pdfCoeff(1), pdfCoeff(2));
        Flow = cdf(Model.distribution, x-0.5*dx, pdfCoeff(1), pdfCoeff(2));
end
fbar = (Fhigh - Flow)./dx;
end

% Author: Andras F. Haselsteiner