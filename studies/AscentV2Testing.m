elem = SingleBodyAscent('Ascentv2');
elem.initialize();

sim = Simulation(elem);

sim.endTime = 5.1;

sim.timeProfile = 0:sim.simElement.timeStep:sim.endTime;

sim.simInput = struct();
sim.simInput.Time = sim.timeProfile;

sim.simInput.windVelocity_E = sim.timeProfile;
sim.simInput.temperature_atm = sim.timeProfile;
sim.simInput.pressure_atm = sim.timeProfile;
sim.simInput.density_atm = sim.timeProfile;
sim.simInput.thrust_B = sim.timeProfile;
sim.simInput.motorMass = sim.timeProfile;
sim.simInput.motorProperties = sim.timeProfile;
sim.simInput.envConstants = sim.timeProfile;
sim.simInput.flightState = sim.timeProfile;
sim.simInput.towerVector = sim.timeProfile;
sim.simInput.rocketEmptyMass = sim.timeProfile;
sim.simInput.rocketEmptyXcg = sim.timeProfile;
sim.simInput.motorInertias = sim.timeProfile;
sim.simInput.kinViscosity_atm = sim.timeProfile;
sim.simInput.airbrakeCmdAngle = sim.timeProfile;

bdclose all;
sim.configureModel();
sim.openModel();

%sim.run();