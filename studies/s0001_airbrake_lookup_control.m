%=========================================================================%
% Airbrake Lookup Control Study
% Date: April 27th 2019
%
% Description:
% This is the study that will determine the lookup table which will be
% implemented on flight avionics. The avionics characterization model will 
% be used in the Jackalope model to run this study. 
%
% Parameters Involved:
% Avionics :: airbrakeDeploySpeed
% Avionics :: airbrakeDeployCmd
%
% Outputs Considered:
% Position_E, velocity_E, acceleration_E,
%
% ========================================================================%

% Specify desired range of involved parameters for the study
deploySpeedRange = 50:10:250;
deployCmdRange = [0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0];

% Setting up the simulation Element (ie. Jackalope) and Simulation object
elem = SingleStageSolidRocket('Jackalope');
elem.initialize();

sim = Simulation(elem);

sim.endTime = 1500;
sim.timeProfile = 0:sim.simElement.timeStep:sim.endTime;

sim.simInput = struct();
sim.simInput.time = sim.timeProfile;

%Run the study
for dsr = deploySpeedRange
    for dcr = deployCmdRange
        sim.simElement.avionics.airbrakeDeploySpeed = dsr;
        sim.simElement.avionics.airbrakeDeployCmd = dcr;
        sim.run();
    end
end
        
