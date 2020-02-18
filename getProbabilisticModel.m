function ProbModel = getProbabilisticModel(index)
%GETENVIRONMENTALPDFMODEL returns a stored probabilitistic model
%   1 = Vanem and Bitner-Gergersen (2012)
%   2 = Mixture model 1 from Haselsteiner et al. (2017) (much density overlap)
%   3 = Mixture model 2 from Haselsteiner et al. (2017) (little density overlap)
%   4 = 3 dimensional model
%   5 = 4 dimensional model
%   6 = 3 dimensional model with two highest density regions
%   7 = Non-parametric model based on kernel density estimation (2D)
%   8 = Non-parametric model based on kernel density estimation (3D)
%   9 = Wind-wave model for the FINO1 site
%
%   Feel free to add your probabilistic model (see line 159 & 170)

% Model 1
ProbModelVanem2012.name = 'Vanem and Bitner-Gregersen (2012)';
ProbModelVanem2012.modelType = 'CMA';
ProbModelVanem2012.distributions = {'weibull'; 'lognormal'};
ProbModelVanem2012.isConditionals = {[0 0 0]; [1 1]};
ProbModelVanem2012.coeffs = {{2.776 1.471 0.8888}; 
                             { @(x1)0.1000 + 1.489 * x1^0.1901;
                               @(x1)0.0400 + 0.1748 * exp(-0.2243*x1)}
                            };
ProbModelVanem2012.labels = {'Significant wave height (m)';
                             'Zero-upcrossing period (s)'};
ProbModelVanem2012.gridCenterPoints = {0:0.1:20; 0:0.1:18};

% Model 2
ProbModelMixtureModel1.name = 'mixture model 1 from Haselsteiner et al. (2017)';
ProbModelMixtureModel1.modelType = 'CMA';
ProbModelMixtureModel1.distributions = {'weibull'; 'lognormnormmixture'};
ProbModelMixtureModel1.isConditionals = {[0 0 0];
                                            [1 1 1 0 0];};
ProbModelMixtureModel1.coeffs = {{2.776 1.471 0.8888};
                                 { @(x1)1 * (1 - exp(-3*x1));
                                   @(x1)0.1000 + 1.489 * x1^0.1901;
                                   @(x1)0.0400 + 0.1748 * exp(-0.2243*x1);
                                   10;
                                   2
                                  }
                                 };
ProbModelMixtureModel1.labels = {'Significant wave height (m)';
                                    'Zero-upcrossing period (s)'};
ProbModelMixtureModel1.gridCenterPoints = {0:0.1:20; 0:0.1:18};

% Model 3
ProbModelMixtureModel2.name = 'mixture model 2 from Haselsteiner et al. (2017)';
ProbModelMixtureModel2.modelType = 'CMA';
ProbModelMixtureModel2.distributions = {'weibull'; 'lognormnormmixture'};
ProbModelMixtureModel2.isConditionals = {[0 0 0]; [1 1 1 0 0];};
ProbModelMixtureModel2.coeffs = {{2.776 1.471 0.8888};
                                    { @(x1)1 * (1 - exp(-3*x1));
                                      @(x1)0.1000 + 1.489 * x1^0.1901;
                                      @(x1)0.0400 + 0.1748 * exp(-0.2243*x1);
                                      15;
                                      0.5
                                    }
                                   };
ProbModelMixtureModel2.labels = {'Significant wave height (m)';
                                    'Zero-upcrossing period (s)'};
ProbModelMixtureModel2.gridCenterPoints = {0:0.1:20; 0:0.1:18};

% Model 4
ProbModelVanem3d.name = 'Vanem and Bitner-Gregersen (2012) 3d';
ProbModelVanem3d.modelType = 'CMA';
ProbModelVanem3d.distributions = {'weibull'; 'lognormal'; 'lognormal'};
ProbModelVanem3d.isConditionals = {[0 0 0]; [1 1]; [1 1]};
ProbModelVanem3d.coeffs = {{2.776 1.471 0.8888};
                           { @(x1)0.1000 + 1.489 * x1^0.1901;
                             @(x1)0.0400 + 0.1748 * exp(-0.2243*x1)
                           };
                           { @(x1,x2)0.1000 + 1.489 * x1^0.1901;
                             @(x1,x2)0.0400 + 0.1748 * exp(-0.2243*x1)
                           }
                          };
ProbModelVanem3d.labels = {'significant wave height (m)';
                           'zero-upcrossing period (s)';
                           'x3 (-)'};
ProbModelVanem3d.gridCenterPoints = {0:1:20; 0:1:18; 0:1:18};

% Model 5
ProbModelVanem4d.name = 'Vanem and Bitner-Gregersen (2012) 4d';
ProbModelVanem4d.modelType = 'CMA';
ProbModelVanem4d.distributions = {'weibull';
                                 'lognormal';
                                 'lognormal';
                                 'lognormal'};
ProbModelVanem4d.isConditionals = {[0 0 0];
                                   [1 1];
                                   [1 1];
                                   [1 1]};
ProbModelVanem4d.coeffs = {{2.776 1.471 0.8888};
                           {@(x1)0.1000 + 1.489 * x1^0.1901;
                            @(x1)0.0400 + 0.1748 * exp(-0.2243*x1)
                           };
                           {@(x1,x2)0.1000 + 1.489 * x1^0.1901;
                            @(x1,x2)0.0400 + 0.1748 * exp(-0.2243*x1)
                           };
                           {@(x1,x2,x3)0.1000 + 1.489 * x1^0.1901;
                            @(x1,x2,x3)0.0400 + 0.1748 * exp(-0.2243*x1)
                           };
                          };
ProbModelVanem4d.labels = {'Significant wave height (m)';
                              'Zero-upcrossing period (s)';
                              'x3 (-)';
                              'x4 (-)';
                             };
ProbModelVanem4d.gridCenterPoints = {0:1:20; 0:1:18; 0:1:18; 0:1:18};

% Model 6
ProbModelMixtureModel23D.name = 'two HDRs 3D';
ProbModelMixtureModel23D.modelType = 'CMA';
ProbModelMixtureModel23D.distributions = {'weibull';
                                             'lognormnormmixture';
                                             'lognormal'};
ProbModelMixtureModel23D.isConditionals = {[0 0 0];
                                              [1 1 1 0 0];
                                              [1 1]};
ProbModelMixtureModel23D.coeffs = {{2.776 1.471 0.8888};
                                      { @(x1)1 * (1 - exp(-3*x1));
                                        @(x1)0.1000 + 1.489 * x1^0.1901;
                                        @(x1)0.0400 + 0.1748 * exp(-0.2243*x1);
                                        16;
                                        0.3};
                                      { @(x1,x2)0.1000 + 1.489 * x1^0.1901;
                                        @(x1,x2)0.0400 + 0.1748 * exp(-0.2243*x1)};
                                     };
ProbModelMixtureModel23D.labels = {'Significant wave height (m)';
                                      'Zero-upcrossing period (s)';
                                      'x3 (-)'};
ProbModelMixtureModel23D.gridCenterPoints = {0:0.5:20; 0:0.5:18; 0:0.5:18};

% Model 7
load('probabilistic-models/ProbModelKDE2d.mat', 'ProbModelKDE2d');

% Model 8
% This model was created by running examples/createMultivariateKDEModel.m
load('probabilistic-models/ProbModelKDE3d.mat', 'ProbModelKDE3d');

% Model 9:
% This model was presented in the OMAE 2020 paper "Global hierarchical 
% models for  wind and wave contours". It represents wind and wave at 
% the North Sea, specifically at the FINO1 platform.
PMWindWaveFINO1.name = 'V-Hs model from X for dataset D (FINO1)';
PMWindWaveFINO1.modelType = 'CMA';
PMWindWaveFINO1.distributions = {'exponentiated-weibull'; 'exponentiated-weibull'};
PMWindWaveFINO1.isConditionals = {[0 0 0 ]; [1 1 0]};
PMWindWaveFINO1.coeffs = {
    {10.0 2.42 0.761}; 
    { 
    @(x1) (0.394 + 0.0178 * x1^1.88) / (2.0445^(1 / (0.582 + 1.90 / (1 + exp(-0.248 * (x1 - 8.49))))));
    @(x1) 0.582 + 1.90 / (1 + exp(-0.248 * (x1 - 8.49)));
    5}
    };
PMWindWaveFINO1.labels = {'Wind speed (m/s)';
    'Significant wave height (m)'};
PMWindWaveFINO1.gridCenterPoints = {0.05:0.1:50; 0.05:0.1:30};

% Define your probabilistic model here.

ProbModelArray = {ProbModelVanem2012;
    ProbModelMixtureModel1;
    ProbModelMixtureModel2;
    ProbModelVanem3d;
    ProbModelVanem4d;
    ProbModelMixtureModel23D;
    ProbModelKDE2d;
    ProbModelKDE3d;
    PMWindWaveFINO1;
    % And add your model to the array here.
    }; 

ProbModel = ProbModelArray{index};

end
