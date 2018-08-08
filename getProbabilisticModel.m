function ModelArray = getProbabilisticModel(index)
%GETENVIRONMENTALPDFMODEL returns a stored probability density model
%   1 = Vanem and Bitner-Gergersen (2012)
%   2 = mixture model 1 (much density overlap)
%   3 = mixture model 2 (little density overlap)
%   4 = 3 dimensional model
%   5 = 4 dimensional model
%   6 = 3 dimensional model with two highest density regions
%
%   feel free to add your probabilistic model (see line 113 & 117)

ModelArrayVanem2012.name = 'Vanem and Bitner-Gregersen (2012)';
ModelArrayVanem2012.gridCenterPoints = {0:0.1:20 0:0.1:18};
ModelArrayVanem2012(1).distribution = 'weibull';
ModelArrayVanem2012(1).isConditional = [0 0 0];
ModelArrayVanem2012(1).coeff = {2.776 1.471 0.8888};
ModelArrayVanem2012(1).label = 'significant wave height [m]';
ModelArrayVanem2012(2).distribution = 'lognormal';
ModelArrayVanem2012(2).isConditional = [1 1];
ModelArrayVanem2012(2).coeff = { @(x1)0.1000 + 1.489 * x1^0.1901;
                    @(x1)0.0400 + 0.1748 * exp(-0.2243*x1)};
ModelArrayVanem2012(2).label = 'zero-upcrossing period [s]';

ModelArrayMixtureModel1.name = 'mixture model 1';
ModelArrayMixtureModel1.gridCenterPoints = {0:0.1:20 0:0.1:18};
ModelArrayMixtureModel1(1).distribution = 'weibull';
ModelArrayMixtureModel1(1).isConditional = [0 0 0];
ModelArrayMixtureModel1(1).coeff = {2.776 1.471 0.8888};
ModelArrayMixtureModel1(1).label = 'significant wave height [m]';
ModelArrayMixtureModel1(2).distribution = 'lognormnormmixture';
ModelArrayMixtureModel1(2).isConditional = [1 1 1 0 0];
ModelArrayMixtureModel1(2).coeff = { @(x1)1 * (1 - exp(-3*x1));
                    @(x1)0.1000 + 1.489 * x1^0.1901;
                    @(x1)0.0400 + 0.1748 * exp(-0.2243*x1);
                    10;
                    2};
ModelArrayMixtureModel1(2).label = 'zero-upcrossing period [s]';

ModelArrayMixtureModel2.name = 'mixture model 2';
ModelArrayMixtureModel2.gridCenterPoints = {0:0.1:20 0:0.1:18};
ModelArrayMixtureModel2(1).distribution = 'weibull';
ModelArrayMixtureModel2(1).isConditional = [0 0 0];
ModelArrayMixtureModel2(1).coeff = {2.776 1.471 0.8888};
ModelArrayMixtureModel2(1).label = 'significant wave height [m]';
ModelArrayMixtureModel2(2).distribution = 'lognormnormmixture';
ModelArrayMixtureModel2(2).isConditional = [1 1 1 0 0];
ModelArrayMixtureModel2(2).coeff = { @(x1)1 * (1 - exp(-3*x1));
                    @(x1)0.1000 + 1.489 * x1^0.1901;
                    @(x1)0.0400 + 0.1748 * exp(-0.2243*x1);
                    15;
                    0.5};
ModelArrayMixtureModel2(2).label = 'zero-upcrossing period [s]';

ModelArrayVanem3d.name = 'Vanem and Bitner-Gregersen (2012) 3d';
ModelArrayVanem3d.gridCenterPoints = {0:1:20 0:1:18 0:1:18};
ModelArrayVanem3d(1).distribution = 'weibull';
ModelArrayVanem3d(1).isConditional = [0 0 0];
ModelArrayVanem3d(1).coeff = {2.776 1.471 0.8888};
ModelArrayVanem3d(1).label = 'significant wave height [m]';
ModelArrayVanem3d(2).distribution = 'lognormal';
ModelArrayVanem3d(2).isConditional = [1 1];
ModelArrayVanem3d(2).coeff = { @(x1)0.1000 + 1.489 * x1^0.1901;
                    @(x1)0.0400 + 0.1748 * exp(-0.2243*x1)};
ModelArrayVanem3d(2).label = 'zero-upcrossing period [s]';
ModelArrayVanem3d(3).distribution = 'lognormal';
ModelArrayVanem3d(3).isConditional = [1 1];
ModelArrayVanem3d(3).coeff = { @(x1,x2)0.1000 + 1.489 * x1^0.1901;
                    @(x1,x2)0.0400 + 0.1748 * exp(-0.2243*x1)};
ModelArrayVanem3d(3).label = 'x3 [-]';

ModelArrayVanem4d.name = 'Vanem and Bitner-Gregersen (2012) 4d';
ModelArrayVanem4d.gridCenterPoints = {0:1:20 0:1:18 0:1:18 0:1:18};
ModelArrayVanem4d(1).distribution = 'weibull';
ModelArrayVanem4d(1).isConditional = [0 0 0];
ModelArrayVanem4d(1).coeff = {2.776 1.471 0.8888};
ModelArrayVanem4d(1).label = 'significant wave height [m]';
ModelArrayVanem4d(2).distribution = 'lognormal';
ModelArrayVanem4d(2).isConditional = [1 1];
ModelArrayVanem4d(2).coeff = { @(x1)0.1000 + 1.489 * x1^0.1901;
                    @(x1)0.0400 + 0.1748 * exp(-0.2243*x1)};
ModelArrayVanem4d(2).label = 'zero-upcrossing period [s]';
ModelArrayVanem4d(3).distribution = 'lognormal';
ModelArrayVanem4d(3).isConditional = [1 1];
ModelArrayVanem4d(3).coeff = { @(x1,x2)0.1000 + 1.489 * x1^0.1901;
                    @(x1,x2)0.0400 + 0.1748 * exp(-0.2243*x1)};
ModelArrayVanem4d(3).label = 'x3 [-]';
ModelArrayVanem4d(4).distribution = 'lognormal';
ModelArrayVanem4d(4).isConditional = [1 1];
ModelArrayVanem4d(4).coeff = { @(x1,x2,x3)0.1000 + 1.489 * x1^0.1901;
                    @(x1,x2,x3)0.0400 + 0.1748 * exp(-0.2243*x1)};
ModelArrayVanem4d(4).label = 'x4 [-]';

ModelArrayMixtureModel23D.name = 'two HDRs 3D';
ModelArrayMixtureModel23D.gridCenterPoints = {0:0.5:20 0:0.5:18 0:0.5:18};
ModelArrayMixtureModel23D(1).distribution = 'weibull';
ModelArrayMixtureModel23D(1).isConditional = [0 0 0];
ModelArrayMixtureModel23D(1).coeff = {2.776 1.471 0.8888};
ModelArrayMixtureModel23D(1).label = 'significant wave height [m]';
ModelArrayMixtureModel23D(2).distribution = 'lognormnormmixture';
ModelArrayMixtureModel23D(2).isConditional = [1 1 1 0 0];
ModelArrayMixtureModel23D(2).coeff = { @(x1)1 * (1 - exp(-3*x1));
                    @(x1)0.1000 + 1.489 * x1^0.1901;
                    @(x1)0.0400 + 0.1748 * exp(-0.2243*x1);
                    16;
                    0.3};
ModelArrayMixtureModel23D(2).label = 'zero-upcrossing period [s]';
ModelArrayMixtureModel23D(3).distribution = 'lognormal';
ModelArrayMixtureModel23D(3).isConditional = [1 1];
ModelArrayMixtureModel23D(3).coeff = { @(x1,x2)0.1000 + 1.489 * x1^0.1901;
                    @(x1,x2)0.0400 + 0.1748 * exp(-0.2243*x1)};
ModelArrayMixtureModel23D(3).label = 'x3 [-]';

% define your probabilistic model here

ModelArrayArray = {ModelArrayVanem2012 ModelArrayMixtureModel1 ...
    ModelArrayMixtureModel2 ModelArrayVanem3d ModelArrayVanem4d ...
    ModelArrayMixtureModel23D}; % and add it to the Array here

ModelArray = ModelArrayArray{index};

end

% Author: Andreas F. Haselsteiner, November 7, 2017