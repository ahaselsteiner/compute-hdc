function ProbModel = getProbabilisticModel(index)
%GETENVIRONMENTALPDFMODEL returns a stored probabilitistic model
%   1 = Vanem and Bitner-Gergersen (2012)
%   2 = mixture model 1 from Haselsteiner et al. (2017) (much density overlap)
%   3 = mixture model 2 from Haselsteiner et al. (2017) (little density overlap)
%   4 = 3 dimensional model
%   5 = 4 dimensional model
%   6 = 3 dimensional model with two highest density regions
%   7 = non-parametric model based on kernel density estimation (2D)
%   8 = non-parametric model based on kernel density estimation (3D)
%
%   Feel free to add your probabilistic model (see line 135 & 139)

% model 1
ProbModelVanem2012.name = 'Vanem and Bitner-Gregersen (2012)';
ProbModelVanem2012.modelType = 'CMA';
ProbModelVanem2012.distributions = {'weibull'; 'lognormal'};
ProbModelVanem2012.isConditionals = {[0 0 0]; [1 1]};
ProbModelVanem2012.coeffs = {{2.776 1.471 0.8888}; 
                             { @(x1)0.1000 + 1.489 * x1^0.1901;
                               @(x1)0.0400 + 0.1748 * exp(-0.2243*x1)}
                            };
ProbModelVanem2012(1).labels = {'significant wave height (m)';
                                'zero-upcrossing period [s]'};
ProbModelVanem2012.gridCenterPoints = {0:0.1:20 0:0.1:18};

% model 2
ProbModelMixtureModel1.name = 'mixture model 1 from Haselsteiner et al. (2017)';
ProbModelMixtureModel1.modelType = 'CMA';
ProbModelMixtureModel1(1).distributions = {'weibull'; 'lognormnormmixture'};
ProbModelMixtureModel1(1).isConditionals = {[0 0 0];
                                            [1 1 1 0 0];};
ProbModelMixtureModel1(1).coeffs = {{2.776 1.471 0.8888};
                                    { @(x1)1 * (1 - exp(-3*x1));
                                      @(x1)0.1000 + 1.489 * x1^0.1901;
                                      @(x1)0.0400 + 0.1748 * exp(-0.2243*x1);
                                      10;
                                      2
                                    }
                                   };
ProbModelMixtureModel1(1).labels = {'significant wave height (m)';
                                    'zero-upcrossing period (s)'};
ProbModelMixtureModel1.gridCenterPoints = {0:0.1:20 0:0.1:18};

% model 3
ProbModelMixtureModel2.name = 'mixture model 2 from Haselsteiner et al. (2017)';
ProbModelMixtureModel2.modelType = 'CMA';
ProbModelMixtureModel2(1).distributions = {'weibull'; 'lognormnormmixture'};
ProbModelMixtureModel2(1).isConditionals = {[0 0 0]; [1 1 1 0 0];};
ProbModelMixtureModel2(1).coeffs = {{2.776 1.471 0.8888};
                                    { @(x1)1 * (1 - exp(-3*x1));
                                      @(x1)0.1000 + 1.489 * x1^0.1901;
                                      @(x1)0.0400 + 0.1748 * exp(-0.2243*x1);
                                      15;
                                      0.5
                                    }
                                   };
ProbModelMixtureModel2(1).labels = {'significant wave height (m)';
                                    'zero-upcrossing period (s)'};
ProbModelMixtureModel2.gridCenterPoints = {0:0.1:20 0:0.1:18};

% model 4
ProbModelVanem3d.name = 'Vanem and Bitner-Gregersen (2012) 3d';
ProbModelVanem3d.modelType = 'CMA';
ProbModelVanem3d(1).distributions = {'weibull'; 'lognormal'; 'lognormal'};
ProbModelVanem3d(1).isConditionals = {[0 0 0]; [1 1]; [1 1]};
ProbModelVanem3d(1).coeffs = {{2.776 1.471 0.8888};
                              { @(x1)0.1000 + 1.489 * x1^0.1901;
                                @(x1)0.0400 + 0.1748 * exp(-0.2243*x1)
                              };
                              { @(x1,x2)0.1000 + 1.489 * x1^0.1901;
                                @(x1,x2)0.0400 + 0.1748 * exp(-0.2243*x1)
                              }
                             };
ProbModelVanem3d(1).labels = {'significant wave height (m)';
                               'zero-upcrossing period (s)';
                               'x3 (-)'};
ProbModelVanem3d.gridCenterPoints = {0:1:20 0:1:18 0:1:18};

% model 5
ProbModelVanem4d.name = 'Vanem and Bitner-Gregersen (2012) 4d';
ProbModelVanem4d.modelType = 'CMA';
ProbModelVanem4d(1).distributions = {'weibull';
                                     'lognormal';
                                     'lognormal';
                                     'lognormal'};
ProbModelVanem4d(1).isConditionals = {[0 0 0];
                                      [1 1];
                                      [1 1];
                                      [1 1]};
ProbModelVanem4d(1).coeffs = {{2.776 1.471 0.8888};
                              { @(x1)0.1000 + 1.489 * x1^0.1901;
                                @(x1)0.0400 + 0.1748 * exp(-0.2243*x1)
                              };
                              { @(x1,x2)0.1000 + 1.489 * x1^0.1901;
                                @(x1,x2)0.0400 + 0.1748 * exp(-0.2243*x1)
                              };
                              { @(x1,x2,x3)0.1000 + 1.489 * x1^0.1901;
                                @(x1,x2,x3)0.0400 + 0.1748 * exp(-0.2243*x1)
                              };
                             };
ProbModelVanem4d(1).labels = {'significant wave height (m)';
                              'zero-upcrossing period (s)';
                              'x3 (-)';
                              'x4 (-)';
                             };
ProbModelVanem4d.gridCenterPoints = {0:1:20 0:1:18 0:1:18 0:1:18};

% model 6
ProbModelMixtureModel23D.name = 'two HDRs 3D';
ProbModelMixtureModel23D.modelType = 'CMA';
ProbModelMixtureModel23D(1).distributions = {'weibull';
                                             'lognormnormmixture';
                                             'lognormal'};
ProbModelMixtureModel23D(1).isConditionals = {[0 0 0];
                                              [1 1 1 0 0];
                                              [1 1]};
ProbModelMixtureModel23D(1).coeffs = {{2.776 1.471 0.8888};
                                      { @(x1)1 * (1 - exp(-3*x1));
                                        @(x1)0.1000 + 1.489 * x1^0.1901;
                                        @(x1)0.0400 + 0.1748 * exp(-0.2243*x1);
                                        16;
                                        0.3};
                                      { @(x1,x2)0.1000 + 1.489 * x1^0.1901;
                                        @(x1,x2)0.0400 + 0.1748 * exp(-0.2243*x1)};
                                     };
ProbModelMixtureModel23D(1).labels = {'significant wave height [m]';
                                      'zero-upcrossing period [s]';
                                      'x3 [-]'};
ProbModelMixtureModel23D.gridCenterPoints = {0:0.5:20 0:0.5:18 0:0.5:18};

% model 7
load('probabilistic_models/ProbModelKDE2d.mat', 'ProbModelKDE2d');

% Define your probabilistic model here.

ProbModelArray = {ProbModelVanem2012 ProbModelMixtureModel1 ...
    ProbModelMixtureModel2 ProbModelVanem3d ProbModelVanem4d ...
    ProbModelMixtureModel23D, ProbModelKDE2d}; % And add it to the array here.

ProbModel = ProbModelArray{index};

end

% Author: Andreas F. Haselsteiner