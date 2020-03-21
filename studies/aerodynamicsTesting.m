elem = SingleBodyAero('barrowmanExt');
elem.initialize();

sim = Simulation(elem);

sim.endTime = 12;
sim.timeProfile = 0:sim.simElement.timeStep:sim.endTime;

% Placeholder Inputs! Change as Necessary
sim.simInput = struct();
sim.simInput.temperature_atm = 25.*ones(size(sim.timeProfile));
sim.simInput.pressure_atm = 101.3.*ones(size(sim.timeProfile));
sim.simInput.density_atm = 1.225.*ones(size(sim.timeProfile));
sim.simInput.windVelocity_B = 5.*ones(size(sim.timeProfile));
sim.simInput.kinematicVelocity_B = 5.*ones(size(sim.timeProfile));
sim.simInput.kinViscosity_atm = 5.*ones(size(sim.timeProfile));

bdclose all;
sim.configureModel();
sim.openModel();

