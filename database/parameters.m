function retParams = parameters(seek)
%PARAMETERS Returns the desired parameters for Simulation Elements
%   This function will act not only as a function to retrieve parameters
%   used to initialize Simulation Elements but also as the master parameter
%   database. In other words, this is the base truth of parameters that are
%   known.

retParams = struct();

%% Parameters for Rocket Elements
if (seek == "Jackalope")
end

%% Parameters for Aero Elements
if (seek == "Aerov1")
            
    %Inertia Matrix
    retParams.InertiaMatNoEngine = 0;

    %body diameters
    retParams.dn = 0;                             % diameter at nosecone base                                     [m]
    retParams.db = 0;                             % average diameter of body                                      [m]
    retParams.df = 0;                             % diameter of body at leading point of fin                      [m]
    retParams.du = 0;                             % diameter at body at starting of tail cone                     [m]
    retParams.dd = 0;                             % diameter of bottom on tail cone                               [m]

    %body lengths
    retParams.ln = 0;                             % length of nosecone                                            [m]
    retParams.lb = 0;                             % length of body                                                [m]
    retParams.lc = 0;                             % length of tailcone                                            [m]
    retParams.l_TS = 0;                           % total horizontal length (ie. fin tip to fin tip)              [m]
    retParams.l_TR = 0;                           % total vertical length of rocket                               [m]

    %body areas
    retParams.Ar = 0;                             % reference area (base of nosecone)                             [m^2]
    retParams.A_fp = 0;                           % fin planform area                                             [m^2]
    retParams.A_fe = 0;                           % exposed fin planform area                                     [m^2]

    %fin geometry
    retParams.lr = 0;                             % fin root length                                               [m]
    retParams.lt = 0;                             % fin tip length                                                [m]
    retParams.lw = 0;                             % fin root length - fin tip length                              [m]
    retParams.lm = 0;                             % fin major length                                              [m]
    retParams.ls = 0;                             % fin horizontal length                                         [m]
    retParams.tf = 0;                             % fin thickness                                                 [m]
    retParams.nf = 0;                             % number of fins                                                [dimless]

    % Inportant Locations
    retParams.Xf = 0;                             %Fin location from nosetip                                      [m]
    retParams.Xc = 0;                             %Tail cone location from nosetip                                [m]
    retParams.Xcp = 0;                            %center of pressure location from nosetip                       [m]

    % other coeffs
    retParams.K_BF = 0;                           % coefficient that accounts for increase in normal force due to fin interference
                                                  %                                                               []
    retParams.Rs = 0;                             % fin section ratio                                             []
    retParams.k_fb = 0;                           % fin-body infereference coeff                                  [] 
    retParams.k_bf = 0;                           % body-fin intereference coeff                                  []
    retParams.del = 0;                            % experimental coeff 1 (to calculate AoA effects)               []
    retParams.eta = 0;                            % experimental coeff 2 (to calculate AoA effects)               []

end 

%% Parameters for Propulsion Elements
if (seek == "SolidMotor")
    
    % engine locations
    retParams.X_GM = 0;                           % engine location from nose tip                     [m]
    retParams.X_CG_full = 0;                      % location of cg of engine from X_GM                [m]
    
    % other motor params
    retParams.Ae = 0.001;                         % exit area of nozzle                               [m^2]
    retParams.thrustProfile = [0 0.12 0.21 0.6 0.9 1.2 1.5 1.8 2.1 2.4 2.7 2.99 3.0;...
                               0 2600 2482 2715 2876 2938 2889 2785 2573 2349 2182 85 0];                  
                                                  % a thrust-time profile to describe thrust          [N]
                                                  
    retParams.m_wet = 6.258;                      % full mass of motor                                [Kg]
    retParams.m_dry = 2.835;                      % empty mass of motor                               [Kg]
    retParams.massProfile = [0 0.12 0.21 0.6 0.9 1.2 1.5 1.8 2.1 2.4 2.7 2.99 3.0;...
                             3.423 3.35069 3.24469 2.77495 2.38622 1.98198 1.57684 1.18234 0.809811 0.467594 0.152563 .000196996 0];
                                                  % mass as a function of time                        [Kg]  
    
    % grain geometery
    retParams.d_initalgrainInner = 0;             % grain initial inner diameter                      [m]
    retParams.d_grainOuter = 0;                   % grain outerdiameter                               [m]
    retParams.l_grain = 0.548;                    % grain length                                      [m]

end

%% Parameters for Recovery Elements
if (seek == "SingleChute")
    
    % parachute system geometry
    retParams.d_parachute = 2.1;                  % parachute diameter                                            [m]
    retParams.l_riser = 5;                        % nominal length of riser (modeling all lines)                  [m]
    retParams.X_briddle = 0.5;                    % location of briddle (riser connection point)                  [m]

    % other parachute params
    retParams.k_lines = 200;                      % spring constant of modeled lines                              []
    retParams.c_lines = 10;                       % damping ratio of modeled lines                                []
    retParams.c_d = 1.226;                        % coefficient of drag                                           []
    retParams.mass_p = 1.1;                       % mass of parachute                                             [Kg]
    retParams.inertiaMatP = [0 0 0;               % inertia matrix of parachute                                   [Kg*m^2]
                             0 0 0;
                             0 0 0];
    
    % tumbling rocket params
    retParams.mass_r = 19.5;                      % mass of tumbling rocket                                       [Kg]
    retParams.X_roff = 0.6;                       % location of riser connection point to tumbling rocket body    [m]
    retParams.inertiaMatR = [0 0 0;               % inertia matrix of tumbling rocket (modeled as cylinder)       [Kg*m^2]
                             0 0 0;
                             0 0 0];
end

%% Parameters for Avionics Elements
if (seek == "Avionicsv1")
end 

%% Parameters for Payload Elements
if (seek == "payload2019")
end

%% Parameters for Sequencer Elements
if (seek == "FSv1")
    retParams.initialFlightState = 0;                  % the starting state of flight (typically pre-ignition)
    retParams.launchTowerLength = 5.18;                % length of launch tower                                         [m]
    retParams.launchTowerOrientation = [0;0;0];        % orientation (euler angles) of launch tower wrt earth-fixed     [rad]
end

%% Parameters for Environment Elements
if (seek == "Earthv1")
        
    % emperical wind parameters
    retParams.Z_roughness = 0;                         % roughness length of terrain
    retParams.atmospheric_coeff = 0.273;               % emperial coefficient for wind speed calculation

    % measured wind parameters
    retParams.referenceWindSpeed = 20;                 % the 'measured' wind speed as a reference                       [m/s]
    retParams.referenceWindAltitude = 10;              % the altitude where reference speed was 'measured'              [m]
    retParams.referenceWindAngle = 0;                  % the angle of wind from 'x-axis (ie. encoded wind direction)    [rad]
    
    % measured static conditions used to interpolate
    retParams.referenceStaticAltitude = 2000;          % the altitude where static conditions were 'measured'    [m]
    retParams.temperatureAtStaticAlt = 253;            % the 'measured' temperature at static altitude           [K]
    retParams.temperatureAtGround = 293;               % the 'measured' temperature on 0 AGL                     [K]
    retParams.pressureAtStaticAlt = 79900;             % the 'measured' pressure at static altitude              [Pa]
    retParams.pressureAtGround = 101325;               % the 'measured' pressure at 0 AGL                        [Pa]

end

end

