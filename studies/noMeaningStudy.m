%% Manifesto
% This 'noMeaningStudy' is meant to act as a tutorial for any who wish to
% develop an aptitude for flight dynamics and performance modeling. The 
% following steps act as a guidelines for running any simulations and 
% processing the results.

%% Create Simulation Element (ie. the model to be simulated)
elem = SingleStageSolidRocket('Jackalope');

%% Initialize Simulation Element with correct values
%  This can be done in many ways, ranging from manual input to importing
%  values autonomously (and any hybrid combination of the two). One
%  parameter that all elements share is timeStep. This parameter determines
%  what discretization the simulation will run at for the corresponding
%  block in simulink - specify this parameter here.
elem.initialize();

%% Create a Simulation Object
%  This is the object that will handle transforming the Simulation Element
%  to a format that simulink likes, configuring/running the simulink model 
%  and making the results available.

sim = Simulation(elem);

%% Provide the Simulation object with an environment
%  This environment will feed values into the simulation element in the
%  simulink model. It is a good idea to make sure the environment model
%  provided is compatible with the simulation element.

sim.simEnvironment = SimpleEnv('Earthv1');
sim.simEnvironment.initialize();

%% Provide the Simulation object with Inputs
%  Every simulation will need inputs other than that the environment will
%  provide. These inputs depend on which Simulation Element is being
%  considered. Additionally, these inputs must be provided in the format of
%  a structure, unlike the simElement or simEnvironment (which are
%  provided as objects). These inputs define a value for every time step of
%  the simulation.

sim.simInput = struct();
sim.simInput.In1 = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];
%sim.simInput.in2 = [2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2];

bdclose all;
sim.configureModel();

%% Run the simulation and perform any sort of study
%  Different studies will require different #s of runs and different sets
%  of data from the simulink model. It is in your hands from here on out;
%  Go forth and find the truth.