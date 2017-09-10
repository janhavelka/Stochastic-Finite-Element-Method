%% General setup
PROBLEM.General.MeshName = 'simple_1x1_899e';
% Name of output file
PROBLEM.General.SaveName = NameSequence('results_simple_fine','output',[],'.mat',[]);
% SaveMode
PROBLEM.General.SaveMode = 1;
% keep statistics about solver etc 
PROBLEM.General.Stats   = 1;


%% Solver setup
% Accuracy of iterative solver (stop iterating if err is below accuracy)
PROBLEM.Solver.Accuracy = 1e-6;
% Maximum iteration steps of solver (stop iteration if iter exeeds NoI)
PROBLEM.Solver.NoI      = 10;
% Regularisation coefficient
PROBLEM.Solver.lambda   = 1e-12;

%% Load definition
% definition of boundary conditions
% [N x 4] cell array of N boundary conditions
% BC{i,1} - [x1 y1;x2 y2] coordinates "from-to" where the BC apply
% BC{i,2} - BC type 'transfer'/'dirichlet'/'neumann'/'robin'
% BC{i,3} - prescribed value of BC. For each type:
%         - 'transfer' - defines a T0 in eq.: q=alpha*(T-T0)
%         - 'dirichlet' - sets the value of potential
%         - 'neumann' - sets the value of fluxes in [flux/m] - is then multiplied by length of element edge
% BC{i,4} - sets the additional information for each BC. For dirichlet/neumann leave the entry empty, i.e. [], 
%           for 'transfer' it defines the transfer coefficient alpha
% The hierarchy is following: 'dirichlet' - 'neumann' - 'transfer', i.e. dirichlet overrides neumann etc.
PROBLEM.LoadDef.BC = {...[0.0 0.6;0.6 0.6],'transfer',30,1e1;... inner left boundary
%                       [0.6 0.6;0.6 0.0],'transfer',30,1e1;... inner right boundary
%                       [1.0 0.0;1.0 1.0],'transfer',15,1e1;... outer right boundary
%                       [1.0 1.0;0.0 1.0],'transfer',15,1e1;... outer left boundary
                      [0.0 1.0;0.0 0.6],'dirichlet',0,1e1;... left boundary
                      [0.6 0.0;1.0 0.0],'transfer',10,1e1};% bottom boundary


%% Material settings
% definition of known material properties
% anisotropy true/false
MATERIAL.Settings.anisotropy=true;

%% Material parameter setup
% obtain gpc coefficients with 'MonteCarlo','Collocation' or 'lhs'
MATERIAL.Settings.RF.Method='lhs';

% Covariance parameters for field 1
MATERIAL.Settings.RF.P{1}.nu=4;
MATERIAL.Settings.RF.P{1}.rho=0.4;
% Covariance parameters for field 2
MATERIAL.Settings.RF.P{2}.nu=4;
MATERIAL.Settings.RF.P{2}.rho=0.4;
% Covariance parameters for field 3
MATERIAL.Settings.RF.P{3}.nu=4;
MATERIAL.Settings.RF.P{3}.rho=0.4;

% correlation between fields
MATERIAL.Settings.RF.C=[1  0.6 0.2;
             0.6  1  0.2;
             0.2 0.2  1];
MATERIAL.Settings.RF.VAR=[(0.2*3)^2 (0.2*5)^2 (0.3*30)^2];
MATERIAL.Settings.RF.MEAN=[3 5 90];

% field point-wise distribution: 'normal'/'lognormal'
% PROBLEM.RF.sampling={'normal','normal','normal','normal'};
MATERIAL.Settings.RF.sampling={'lognormal','lognormal','lognormal'};
% choose covariance function for each field:
% - 'matern' parameters: rho - correlation length
%                        nu - differentiability
% - 'exponential' parameters: rho - correlation length
% - 'gauss' parameters: rho - correlation length
% - 'periodic' parameters: rho - correlation length
% - 'constant' parameters: rho - correlation
MATERIAL.Settings.RF.covariance={'matern','matern','matern'};
% get the number of random fields
MATERIAL.Settings.RF.N_rf=length(MATERIAL.Settings.RF.P);
% % get the number of eigenmodes for each randomfield = number of Random Variables (for each field)
% PROBLEM.RF.N_rv=30;
% set number of random variables: either choose the number of variables or percent of
% variance is reahced
MATERIAL.Settings.RF.N_rv=10;
MATERIAL.Settings.RF.N_rv_prec=0.9; % choose number on scale <0,1> (1 is the most precise)

% get degree of polynomial to fit the response
MATERIAL.Settings.Collocation.DoP=3;
% get the accuracy of fit
MATERIAL.Settings.Collocation.Accuracy=5;

% Four quadrature rules for D-dimensional numerical integration are implemented:
%     Rules for the unweighted integration: ?=[0,1]D, f(x)=1
%         GQU: Univariate Gaussian quadrature rules as basis
%         KPU: Univariate nested quadrature rules as basis - delayed Kronrod-Patterson rules, see Knut Petras (2003): "Smolyak cubature of given polynomial degree with few nodes for increasing dimension." Numerische Mathematik 93, 729-753.
%     Rules for the integration over ?=RD with Gaussian weight f(x)=exp(-x'x/2)/sqrt(2?)
%         GQN: Univariate Gaussian quadrature rules as basis
%         KPN: Univariate nested quadrature rules as basis, see A. Genz and B. D. Keister (1996): "Fully symmetric interpolatory rules for multiple integrals over infinite regions with Gaussian weight." Journal of Computational and Applied Mathematics 71, 299-309.
MATERIAL.Settings.Collocation.QuadRule='GQN';


%% Load Mesh
MESH = load(fullfile('mesh',PROBLEM.General.MeshName),'-mat');