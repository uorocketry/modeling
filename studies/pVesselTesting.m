elem = NitrousTank('NitrousTank');
elem.initialize();

sim = Simulation(elem);

sim.endTime = 5.0;
sim.timeProfile = [0 sim.endTime];

sim.simInput = struct();
sim.simInput.pressureOxi = [745 700];

bdclose all;
sim.configureModel();
%sim.openModel()

%sim.run();
