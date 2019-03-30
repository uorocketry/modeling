elem = FSv1('FSv1');
elem.initialize();

sim = Simulation(elem);

sim.endTime = 100;
sim.timeProfile = 0:sim.simElement.timeStep:sim.endTime;

sim.simInput = struct();
sim.simInput.position_E = [1 2 3;
                           1 2 3;
                           1 2 3];
sim.simInput.orientation = [1 2 3;
                            1 2 3;
                            1 2 3];
sim.simInput.velocity_E = [1 2 3;
                           1 2 3;
                           1 2 3];
sim.simInput.thrust_B = [1 2 3;
                         1 0 0;
                         1 0 0];

bdclose all;
sim.configureModel();
