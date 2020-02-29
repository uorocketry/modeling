%% Manifesto
% This 'noMeaningStudy' is meant to act as a tutorial for any who wish to
% develop an aptitude for flight dynamics and performance modeling. The 
% following steps act as a guidelines for running any simulations and 
% processing the results.

%% Create Simulation Element (ie. the model to be simulated)
elem = SimpleEnv('Earthv2');

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

%% Provide the Simulation object with Inputs and 'user' inputs
%  Every simulation will need inputs; these inputs depend on which 
%  Simulation Element is being considered. Additionally, these inputs must 
%  be provided in the format of a structure, unlike the simElement or 
%  simEnvironment (which are provided as objects). These inputs define a 
%  value for every time step of the simulation.

sim.endTime = 200;

sim.timeProfile = 0:sim.simElement.timeStep:sim.endTime;
altitudeProfile = [0 100000];

altProfileTime = [0 sim.endTime];

sim.simInput = struct();
sim.simInput.altitude_E = interp1(altProfileTime, altitudeProfile, sim.timeProfile);

sim.simElement.referenceWindAngle = 0.69;
sim.simElement.referenceWindSpeed = 4;
sim.simElement.temperatureOffset = 6;

sim.simElement.windSpeedVarience = 0.2;
sim.simElement.windAngleVarience = 0.05;
sim.simElement.temperatureVarience = 2;

sim.simElement.randomSeed = 0;

bdclose all;
sim.configureModel();
sim.openModel();

%% Run the simulation and perform any sort of study
%  Different studies will require different #s of runs and different sets
%  of data from the simulink model. It is in your hands from here on out;
%  Go forth and find the truth.