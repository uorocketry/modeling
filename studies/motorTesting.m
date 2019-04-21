elem = SolidMotor('SolidMotor');
elem.initialize();

sim = Simulation(elem);

sim.endTime = 5.1;

sim.timeProfile = 0:sim.simElement.timeStep:sim.endTime;

sim.simInput = struct();
sim.simInput.time = sim.timeProfile;

%bdclose all;
%sim.configureModel();

sim.run();
