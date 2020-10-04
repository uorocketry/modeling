elem = NitrousTank('nitrousTank1');
elem.initialize();

sim = Simulation(elem);

sim.endTime = 20.0;
sim.timeProfile = [0 sim.endTime];

sim.simInput = struct();
sim.simInput.massFlow = [1.2 1.1];
sim.simInput.temperature_atm = [30 30];

bdclose all;
sim.configureModel();
sim.openModel()

%sim.run();
