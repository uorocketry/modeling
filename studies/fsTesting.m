elem = FSv1('FSv1');
elem.initialize();

sim = Simulation(elem);

sim.endTime = 10;
sim.timeProfile = [0 2 4 6 8 9 sim.endTime];
 
sim.simInput = struct();
sim.simInput.position_E = [0 0   0    0   0   0 0;
                           0 0   0    0   0   0 0;
                           0 500 3000 200 100 10 0];
                       
sim.simInput.orientation = [0 0 0 0 0 0 0;
                            0 0 0 0 0 0 0;
                            0 0 0 0 0 0 0];
                        
sim.simInput.velocity_E = [0 0   0 0   0  0 0; 
                           0 0   0 0   0  0 0;
                           0 300 0 -20 -9 0 0];
                       
sim.simInput.descentOneDeploy = [0 0 0 0 1 1 1];

sim.simInput.descentTwoDeploy = [0 0 0 0 0 1 1];

sim.simInput.thrust_B = [1000 1000 0 0 0 0 0;
                         0    0    0 0 0 0 0;
                         0    0    0 0 0 0 0];

%bdclose all;
%sim.configureModel();
%sim.openModel();

sim.run();