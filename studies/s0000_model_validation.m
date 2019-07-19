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

sim.endTime = 100;
sim.timeProfile = 0:sim.simElement.timeStep:sim.endTime;

sim.simInput = struct();
sim.simInput.time = sim.timeProfile;

% bdclose all;
% sim.configureModel();
% sim.openModel();

res = sim.run();

% find desired quantities in results datastructure
position_E = res.find('position_E');
velocity_E = res.find('velocity_E');
apparentVelocityMag = res.find('VaMag_B');
acceleration_E = res.find('acceleration_E');
mach = res.find('mach');

% plot the desired quantities
figure;
position_E.Values.plot();
grid;

figure;
velocity_E.Values.plot();
grid;

figure;
apparentVelocityMag.Values.plot();
grid;

figure;
acceleration_E.Values.plot();
grid;

figure;
mach.Values.plot();
grid;

%Create data matrix and save to file
time = position_E.Values.Time;
positionData = [position_E.Values.Data(:,1) position_E.Values.Data(:,2) position_E.Values.Data(:,3)];
velocityData = [velocity_E.Values.Data(:,1) velocity_E.Values.Data(:,2) velocity_E.Values.Data(:,3)];
appaerntVelocityMagData = apparentVelocityMag.Values.Data;
accelerationData = [acceleration_E.Values.Data(:,1) acceleration_E.Values.Data(:,2) acceleration_E.Values.Data(:,3)];
mach = mach.Values.Data;

dataMatrix = [time positionData velocityData appaerntVelocityMagData accelerationData mach];
csvwrite('results\s0000_data.csv', dataMatrix);