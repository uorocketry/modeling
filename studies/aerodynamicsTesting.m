elem = SingleBodyAero('barrowmanExt');
elem.initialize();

sim = Simulation(elem);

sim.endTime = 12;
sim.timeProfile = 0:sim.simElement.timeStep:sim.endTime;

initEuler = [0;(-90)*(pi/180);0];
phi_2 = initEuler(1)/2;
theta_2 = initEuler(2)/2;
psi_2 = initEuler(3)/2;

initQuaternions = [ cos(phi_2)*cos(theta_2)*cos(psi_2) + sin(phi_2)*sin(theta_2)*sin(psi_2);...
                    sin(phi_2)*cos(theta_2)*cos(psi_2) - cos(phi_2)*sin(theta_2)*sin(psi_2);...
                    cos(phi_2)*sin(theta_2)*cos(psi_2) + sin(phi_2)*cos(theta_2)*sin(psi_2);...
                    cos(phi_2)*cos(theta_2)*sin(psi_2) - sin(phi_2)*sin(theta_2)*cos(psi_2)];

RM = quat2dcm(initQuaternions');

constApparentWindVel_E = [5; 5; 0];
constApparaentWindVel_B = RM*constApparentWindVel_E;

kinematicVelX_B = [0 500];
kinematicVelY_B = [0 0];
kinematicVelZ_B = [0 0];
kvSimTime_B = [0 sim.endTime];

% Placeholder Inputs! Change as Necessary
sim.simInput = struct();
sim.simInput.quaternions =          initQuaternions.*(ones([4 length(sim.timeProfile)]));      
sim.simInput.temperature_atm =      25.*ones(size(sim.timeProfile));
sim.simInput.pressure_atm =         101.3.*ones(size(sim.timeProfile));
sim.simInput.density_atm =          1.225.*ones(size(sim.timeProfile));
sim.simInput.windVelocity_B =       constApparaentWindVel_B.*(ones([3 length(sim.timeProfile)]));
sim.simInput.kinViscosity_atm =     (1.46e-5).*ones(size(sim.timeProfile));

sim.simInput.kinematicVelocity_B =  ones([3 length(sim.timeProfile)]);
sim.simInput.kinematicVelocity_B(1,:) = interp1(kvSimTime_B, kinematicVelX_B, sim.timeProfile);
sim.simInput.kinematicVelocity_B(2,:) = interp1(kvSimTime_B, kinematicVelY_B, sim.timeProfile);
sim.simInput.kinematicVelocity_B(3,:) = interp1(kvSimTime_B, kinematicVelZ_B, sim.timeProfile);


bdclose all;
sim.configureModel();
sim.openModel();

