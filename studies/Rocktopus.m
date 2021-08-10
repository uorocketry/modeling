elem = SingleStageHybridRocket('Rocktopus');
elem.initialize();   

elem.ascent.aerodynamics.dn=0.1524;                     % diameter at nosecone base                                     [m]
elem.ascent.aerodynamics.db = 0.154;                    % average diameter of body                                      [m]
elem.ascent.aerodynamics.df = 0.1555;                   % diameter of body at leading point of fin                      [m]
elem.ascent.aerodynamics.du = 0.1555;                   % diameter at body at starting of tail cone                     [m]
elem.ascent.aerodynamics.dd = 0.1244;                   % diameter of bottom on tail cone                               [m]

elem.ascent.aerodynamics.ln = 0.5334;                               % length of nosecone                                            [m]
elem.ascent.aerodynamics.lb = 4.38858;                               % length of body                                                [m]
elem.ascent.aerodynamics.lc = 0.04382;                                 % length of tailcone                                            [m]
elem.ascent.aerodynamics.l_TR = 4.96581;                             % total vertical length of rocket                               [m]

elem.ascent.aerodynamics.lr = 0.25;                                % fin root length                                               [m]
elem.ascent.aerodynamics.lt = 0.13;                                % fin tip length                                                [m]
elem.ascent.aerodynamics.ls = 0.138;                               % fin horizontal length                                         [m]
elem.ascent.aerodynamics.tf = 0.003;                               % fin thickness                                                 [m]
elem.ascent.aerodynamics.nf = 3;                                   % number of fins                                                [dimless]
elem.ascent.aerodynamics.ltrt = 0.11;                              % Top of root to top of tip                                     [m]
elem.ascent.aerodynamics.macLead = 0.04921;                        % Dist btwn top of root to top of MAC                           [m]



sim = Simulation(elem);

sim.endTime = 1500;

sim.timeProfile = 0:sim.simElement.timeStep:sim.endTime;

sim.simInput = struct();
sim.simInput.time = sim.timeProfile;

bdclose all;
sim.configureModel();
sim.openModel();