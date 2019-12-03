PM.name = 'Exponentiated Weibull distribution';
PM.modelType = 'CMA';
PM.distributions = {'exponentiated-weibull'; 'exponentiated-weibull'};
PM.isConditionals = {[0 0 0]; [1 1 1]};
PM.coeffs = {{11 2.5 0.54}; 
    { 
    @(x1)0.23 * exp(0.13 * x1);
    @(x1)0.69 * exp(0.045 * x1);
    @(x1)1 + 16 * exp(-1*(x1 - 15)^2 / 110)}
    };
PM(1).labels = {'Wind speed (m/s)';
    'significant wave height (m)'};
PM.gridCenterPoints = {0.05:0.1:50; 0.05:0.1:30};

n_years = 50;
alpha = 1 / (n_years * 365.25 * 24);
[fm, x1Hdc, x2Hdc, x3Hdc, x4Hdc] = computeHdc(PM, alpha, PM.gridCenterPoints, 1);
