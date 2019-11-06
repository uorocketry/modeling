elem = HybridEngine('HREV1');
elem.initialize();

sim = Simulation(elem);

sim.endTime = 50;
sim.timeProfile = 0:sim.simElement.timeStep:sim.endTime;

% setting up inputs (do not change as these are the control conditions)
sim.simInput = struct();
sim.simInput.time = sim.timeProfile;
sim.simInput.valveCmd = 0*sim.timeProfile;
sim.simInput.temp_atm = 25.*ones(size(sim.timeProfile));
sim.simInput.pressure_atm = 101.3.*ones(size(sim.timeProfile));
sim.simInput.density_atm = 1.225.*ones(size(sim.timeProfile));

% Primary Design Parameters for Hybrid Engine
AtList =          [1e-3 1e-3 1e-3 1e-3 0.0058 0.0058 0.0058 0.0058 0.0058 0.0058 0.0058 0.0058 1e-3 1e-3 1e-3 1e-3 1e-3 1e-3 1e-3 1e-3 0.0058 0.0058 0.0058 0.0058];                         
initOxiMassList = [8 8 14 14 14 14 8 14 14 8 8 8 8 8 14 14 14 14 8 8 8 8 14 14];
nIHolesList =     [11 11 21 21 11 11 21 21 21 21 11 11 21 21 11 11 21 21 11 11 21 21 11 11];                      
d_ihList =        [0.001 0.002 0.002 0.001 0.001 0.002 0.002 0.002 0.002 0.001 0.001 0.002 0.002 0.001 0.001 0.002 0.002 0.001 0.001 0.002 0.002 0.001 0.001 0.002];                  
Dfg_innerList =   [0.02 0.06 0.06 0.02 0.06 0.02 0.02 0.06 0.06 0.02 0.02 0.06 0.02 0.06 0.06 0.02 0.06 0.02 0.02 0.06 0.02 0.06 0.06 0.02];
Dfg_outerList =   [0.085 0.15 0.085 0.15 0.15 0.085 0.15 0.15 0.015 0.085 0.15 0.085 0.085 0.15 0.085 0.15 0.15 0.085 0.15 0.085 0.085 0.15 0.085 0.15];                 
LfgList =         [0.3 1 0.3 1 0.3 1 0.3 1 1 0.3 1 0.3 1 0.3 1 0.3 1 0.3 1 0.3 1 0.3 1 0.3];

delVList = [];
Isp_avgList = [];

for c = 1:length(AtList)

    % Set the desired parameters 
    elem.oxiTank.initOxiMass = initOxiMassList(c);      % mass of loaded nitrous        [kg]
    elem.A_ih = pi*((d_ihList(c)/2)^2);                 % area of single injector hole  [m^2]
    elem.nIHoles = nIHolesList(c);                      % number of holes in injector   [dimless]
    elem.At = AtList(c);                                % area of nozzle throat         [m^2]
    elem.Dfg_inner = Dfg_innerList(c);                  % initial inner diameter of fuel grain      [m]
    elem.Dfg_outer = Dfg_outerList(c);                  % outer diameter of fuel grain              [m]
    elem.Lfg = LfgList(c);                              % length of fuel grain                      [m]
    
    % Run the simulation
    sim.run();

    % Compute average exit velocity
    propMass = sim.res{15}.Values.Data;
    propGoneAllInx = find(propMass < 0.00001); 
    propGoneFirstIdx = propGoneAllInx(1);
    Ve_avg = mean(sim.res{11}.Values.Data(1:propGoneFirstIdx));

    % Compute average specific impulse
    g_0 = 9.80665;
    Isp_avg = Ve_avg/g_0;

    % Compute delta V (the metric being used for optimization)
    % Assume dry mass is 20kg

    m_f = 20;
    m_i = m_f + sim.simElement.oxiTank.initOxiMass ...
              + sim.simElement.initMassFuel;

    delV = Ve_avg*log(m_i/m_f);
    disp(delV)

    delVList = [delVList delV];
    Isp_avgList = [Isp_avgList Isp_avg];
    
    figure;
    sim.res{14}.Values.plot();
    grid;
end
