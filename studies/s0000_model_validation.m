%=========================================================================%
% Airbrake Lookup Control Study
% Date: April 28th 2019
%
% Description:
% This is the model validation script that runs the entire model with
% nominal values to get a baseline. 
%
% Parameters Involved:
% Jackalope :: all
% 
%
% Outputs Considered:
% Jackalop :: all
%
% ========================================================================%

% Setting up the simulation Element (ie. Jackalope) and Simulation object
elem = SingleStageSolidRocket('Jackalope');
elem.initialize();

sim = Simulation(elem);

sim.endTime = 200;
sim.timeProfile = 0:sim.simElement.timeStep:sim.endTime;

sim.simInput = struct();
sim.simInput.time = sim.timeProfile;

bdclose all;
sim.configureModel();
sim.openModel();

%sim.run()
