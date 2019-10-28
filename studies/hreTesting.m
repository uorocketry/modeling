elem = HybridEngine('HREV1');
elem.initialize();

sim = Simulation(elem);

sim.endTime = 20;
sim.timeProfile = 0:sim.simElement.timeStep:sim.endTime;

% setting up inputs (do not change as these are the control conditions)
sim.simInput = struct();
sim.simInput.time = sim.timeProfile;
sim.simInput.valveCmd = 0*sim.timeProfile;
sim.simInput.temp_atm = 25*ones(length(sim.timeProfile));
sim.simInput.pressure_atm = 101.5*ones(length(sim.timeProfile));
sim.simInput.density_atm = 1.225*ones(length(sim.timeProfile));

bdclose all;
sim.configureModel();
sim.openModel();

%sim.run();
