elem = HybridEngine('HREHotFireData');
elem.initialize();


% Primary Design Parameters for Hybrid Engine
elem.oxiTank.initOxiTemp = 20;          % Temperature of nitrous after fill        [deg c]
elem.A_ih = 2.4476e-6;                  % area of single injector hole  [m^2]
elem.nIHoles = 16;                      % number of holes in injector   [dimless]
elem.At = 1e-3;                         % area of nozzle throat         [m^2]
elem.Ae = 0.0058;                       % area of nozzle outlet         [m^2]
elem.Dfg_inner = 0.04;                  % initial inner diameter of fuel grain      [m]
elem.Dfg_outer = 0.134;                 % outer diameter of fuel grain              [m]
elem.Lfg = 0.3;                         % length of fuel grain                      [m]


sim = Simulation(elem);
sim.endTime = 12;
sim.timeProfile = 0:sim.simElement.timeStep:sim.endTime;

%Inputs

sim.simInput = struct();
sim.simInput.time = sim.timeProfile;
sim.simInput.valveCmd = 0*sim.timeProfile;
sim.simInput.temp_atm = 25.*ones(size(sim.timeProfile));
sim.simInput.pressure_atm = 101.3.*ones(size(sim.timeProfile));
sim.simInput.density_atm = 1.225.*ones(size(sim.timeProfile));
sim.simInput.mass_oxi= 50.*ones(size(sim.timeProfile));
sim.simInput.density_oxi= 50.*ones(size(sim.timeProfile)); 
sim.simInput.Tank_pressure = 6000.*ones(size(sim.timeProfile)); % Change
sim.simInput.Pchamber = 50.*ones(size(sim.timeProfile));        %change
 


bdclose all;
sim.configureModel();
sim.openModel();

%sim.run();