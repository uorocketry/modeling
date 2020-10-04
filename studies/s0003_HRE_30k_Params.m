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

% Set Constant Parameters
elem.oxiTank.initOxiMass = 14;          % mass of loaded nitrous                    [kg]
elem.A_ih = pi*(((1.62e-3)/2)^2);       % area of single injector hole              [m^2]
elem.nIHoles = 19;                      % number of holes in injector               [dimless]

% Primary Design Parameters for Hybrid Engine
AtList = 0.001:0.0005:0.01;
Dfg_outerList = (13.5:0.2:15.5)*10^(-2);
Dfg_innerList = (4:0.5:8)*10^(-2);
LfgList = 0.5:0.1:1.2;

runId = 1;

for at = 0.001:0.0005:0.01
    for fgo = (13.5:0.2:15.5)*10^(-2)
        for fgi = (4:0.5:8)*10^(-2)
            for fgl = 0.5:0.1:1.2
                                
                fprintf('Simulation Run %d: at_%d fgo_%d fgi_%d fgl_%d\n', ...
                         runId, at, fgo, fgi, fgl);
                
                elem.At = at;
                elem.Dfg_outer = fgo;
                elem.Dfg_inner = fgi;
                elem.Lfg = fgl;
                
                elem.initMassFuel = elem.rho_fuel*(pi*((elem.Dfg_outer/2)^2 - ...
                                              (elem.Dfg_inner/2)^2)*elem.Lfg);
                
                sim.run();
                
                max_thr = sim.res{14}.Values.max;
                max_OF = sim.res{2}.Values.max;
                
                if(max_thr(1) >= 3000 && max_thr(1) <= 4500)
                    % Compute average exit velocity
                    fuelMass = sim.res{5}.Values.Data;
                    fuelGoneAllInx = find(fuelMass < 0.001); 
                    fuelGoneFirstIdx = fuelGoneAllInx(1);
                    Ve_avg = mean(sim.res{11}.Values.Data(1:fuelGoneFirstIdx));

                    % Compute average specific impulse
                    g_0 = 9.80665;
                    Isp_avg = Ve_avg/g_0;

                    % Compute delta V (the metric being used for optimization)
                    % Assume dry mass is 44kg
                    m_f = 44;
                    m_i = m_f + sim.simElement.oxiTank.initOxiMass ...
                              + sim.simElement.initMassFuel;

                    delV = Ve_avg*log(m_i/m_f);
                    
                    if (max_OF >= 3 && max_OF <=9)
                        thr_profile = sim.res{14}.Values.Data(1:fuelGoneFirstIdx);
                        mass_oxi = sim.res{19}.Values.Data(1:fuelGoneFirstIdx);
                        mass_fuel = sim.res{5}.Values.Data(1:fuelGoneFirstIdx);
                        mass_total = mass_oxi + mass_fuel;
                        mass_total = mass_total + m_f;
                        
                        accel_profile = thr_profile./(mass_total.') - g_0*ones(size(thr_profile));
                        vel_profile = cumtrapz(elem.timeStep, accel_profile);
                        altitude_profile = cumtrapz(elem.timeStep, vel_profile);
                        
                        vi = vel_profile(end);
                        zi = altitude_profile(end);
                        apo = ((vi^2)/(2*g_0)) + zi;
                        
                        row = [runId at fgo fgi fgl Isp_avg vi apo max_OF]; 
                        
                        fprintf('Crossed All Thresholds ID#%d: at_%d fgo_%d fgi_%d fgl_%d\n', ...
                                runId, at, fgo, fgi, fgl)
                        dlmwrite('results\\s0003_HRE_30k_Params\\filteredRes.csv',row,'-append');
                    end
                end
                
                fprintf('Simulation Run Complete %d: at_%d fgo_%d fgi_%d fgl_%d\n', ...
                         runId, at, fgo, fgi, fgl);
                     
                runId = runId + 1;


            end 
        end 
    end
end