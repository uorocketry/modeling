function retParams = parameters(seek)
%PARAMETERS Returns the desired parameters for Simulation Elements
%   This function will act not only as a function to retrieve parameters
%   used to initialize Simulation Elements but also as the master parameter
%   database. In other words, this is the base truth of parameters that are
%   known.

retParams = struct();

%% Parameters for Rocket Elements
if (seek == "Jackalope")
    
        %Rocket Properties no Fuel Grain
        retParams.emptyMass = 16.07851;                 % Mass of rocket without fuelgrain                              [Kg]
        retParams.emptyCG = 0.166771;                   % Center of gravity of rocket without fuelgrain                 [m]
end

%% Parameters for Aero Elements
if (seek == "Aerov1")
            
    %Inertia Matrix
    retParams.InertiaMatNoEngine = [0.06072467685   0.005038703691  -0.001041429427;
                                    0.005038703691  8.592166229     0.0000823036698;
                                    -0.001041429427 0.0000823036698 8.591942518];             
                                                        % inertia matrix of rocket (flight config)                      [Kg*m^2]

    %body diameters
    retParams.dn = 0.14;                                % diameter at nosecone base                                     [m]
    retParams.db = 0.14;                                % average diameter of body                                      [m]
    retParams.df = 0.14;                                % diameter of body at leading point of fin                      [m]
    retParams.du = 0.14;                                % diameter at body at starting of tail cone                     [m]
    retParams.dd = 0.14;                                % diameter of bottom on tail cone                               [m]

    %body lengths
    retParams.ln = 0.548;                               % length of nosecone                                            [m]
    retParams.lb = 2.255;                               % length of body                                                [m]
    retParams.lc = 0.0;                                 % length of tailcone                                            [m]
    retParams.l_TR = 2.803;                             % total vertical length of rocket                               [m]

    %fin geometry
    retParams.lr = 0.25;                                % fin root length                                               [m]
    retParams.lt = 0.13;                                % fin tip length                                                [m]
    retParams.ls = 0.138;                               % fin horizontal length                                         [m]
    retParams.tf = 0.003;                               % fin thickness                                                 [m]
    retParams.nf = 3;                                   % number of fins                                                [dimless]

    % Inportant Locations
    retParams.Xf = 2.553;                               %Fin location from nosetip                                      [m]
    retParams.Xc = 2.803;                               %Tail cone location from nosetip                                [m]
    
    % other coeffs
    retParams.K = 1.1;                                                                  % experimental coeff for correction of stability derivative     []
   
    % airbrake model table data
    retParams.cmdAngleBreakpoints = [0.4 0.6 0.8 1.0];                                  % breakpoints that specify the input cmd airbrake angle         []
    retParams.speedBreakpoints =    [100 150 200 250];                                  % breakpoints that specify the input speed (kinematic, earth)   [m/s] 
    retParams.increaseInAxialDrag = [12.37  28.62  51.65  82.76;...
                                     20.651 47.02  85.97  137.39;...
                                     28.37  64.886 118.55 190.08;...
                                     32.60  74.79  136.88 219.90];                      % delta drag for breakpoint values in table for airbrake model  [N]
    
    % Table Data and breakpoints
    retParams.etaTable = [0.6 0.63 0.66 0.68 0.71 0.73 0.74 0.75 0.76];                 % table for correction factor used in AOA correction            []
    retParams.etaAOABreakpoints = [4 6 8 10 12 14 16 18 20];                            % AOA breakpoints for eta correction factor                     [degree]

    retParams.delTable = [0.783 0.8625 0.925 0.9417 0.96 0.9725 0.975 0.977 0.978];     % table for correction factor used in AOA correction            []
    retParams.delAOABreakpoints = [4 6 8 10 12 14 16 18 20];                            % AOA breakpoints for del correction factor                     [degree]
    
    % Data to pass along into initialization method of SingleBodyAero
    % ie. tower length and orientation
    towerParams = parameters('FSv1');
    retParams.launchTowerLength = towerParams.launchTowerLength;
    retParams.lauchTowerOrientation = towerParams.lauchTowerOrientation;
end 

%% Parameters for Propulsion Elements
if (seek == "SolidMotor")
    
    % engine locations
    retParams.X_GM = 2.244;                                                             % engine location from nose tip                     [m]
    retParams.X_CG_full = 0.2745;                                                       % location of cg of engine from X_GM                [m]
    
    % other motor params
    retParams.Ae = 0.001;                                                               % exit area of nozzle                               [m^2]
    retParams.thrustProfile = [0 0.12 0.21 0.6 0.9 1.2 1.5 1.8 2.1 2.4 2.7 2.99 3.0;...
                               0 2600 2482 2715 2876 2938 2889 2785 2573 2349 2182 85 0];                  
                                                                                        % a thrust-time profile to describe thrust          [N]
                                                  
    retParams.m_wet = 6.258;                                                            % full mass of motor                                [Kg]
    retParams.m_dry = 2.835;                                                            % empty mass of motor                               [Kg]
    retParams.massProfile = [0 0.12 0.21 0.6 0.9 1.2 1.5 1.8 2.1 2.4 2.7 2.99 3.0;...
                             3.423 3.35069 3.24469 2.77495 2.38622 1.98198 1.57684 1.18234 0.809811 0.467594 0.152563 .000196996 0];
                                                                                        % mass as a function of time                        [Kg]  
    
    % grain geometery
    retParams.d_initalgrainInner = 0.05;                                                % grain initial inner diameter                      [m]
    retParams.d_grainOuter = 0.14;                                                      % grain outerdiameter                               [m]
    retParams.l_grain = 0.548;                                                          % grain length                                      [m]

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
    retParams.c_dReefed = 0.75;                   % coefficient of drag in reefed configuration                   []
    retParams.c_dFull = 1.226;                    % coefficient of drag in full configuration                     []
    retParams.mass_p = 1.1;                       % mass of parachute                                             [Kg]
    
    % tumbling rocket params
    retParams.mass_r = 19.5;                      % mass of tumbling rocket                                       [Kg]
    retParams.X_roff = 0.6;                       % location of riser connection point to tumbling rocket body    [m]
    retParams.d_rocket = 0.14;                    % average diameter of rocket NOTE: DEFINED IN AERO AS WELL      [m]
    retParams.l_rocket = 2.803;                   % total length of rocket NOTE: DEFINED IN AERO AS WELL          [m]
end

%% Parameters for Avionics Elements
if (seek == "Avionicsv1")
end 

if (seek == "AvionicsCharacterization")
    % airbrake properties
    retParams.airbrakeDeploySpeed = 0;                  % speed at which to deploy the airbrakes                    [m/s]
    retParams.airbrakeDeployCmd = 0.0;                  % commanded, normalized angle at which to deploy airbrakes  []

    % recovery deployment parameters
    retParams.descentTwoDeployAltitude = 700;           % altitude at which the 2nd deployment charge triggers      [m]
end 

%% Parameters for Payload Elements
if (seek == "payload2019")
end

%% Parameters for Sequencer Elements
if (seek == "FSv1")
    retParams.initialFlightState = 0;                   % the starting state of flight (typically pre-ignition)         [dimless]
    retParams.launchTowerLength = 5.18;                 % length of launch tower                                        [m]
    retParams.lauchTowerOrientation = [0;...
                                       (270+10)*(pi/180);...
                                       0];              % orientation (roll, pitch, yaw) of launch tower                [degree]
end

%% Parameters for Environment Elements
if (seek == "Earthv1")
        
    % emperical wind parameters
    retParams.Z_roughness = 0.03;                       % roughness length of terrain                                    []
    retParams.atmospheric_coeff = 0.273;                % emperial coefficient for wind speed calculation                []

    % measured wind parameters
    retParams.referenceWindSpeed = 4;                   % the 'measured' wind speed as a reference                       [m/s]
    retParams.referenceWindAltitude = 10;               % the altitude where reference speed was 'measured'              [m]
    retParams.referenceWindAngle = 0;                   % the angle of wind from 'x-axis (ie. encoded wind direction)    [rad]
    
    % measured static conditions used to interpolate
    retParams.referenceStaticAltitude = 2000;           % the altitude where static conditions were 'measured'           [m]
    retParams.temperatureAtStaticAlt = 253;             % the 'measured' temperature at static altitude                  [K]
    retParams.temperatureAtGround = 293;                % the 'measured' temperature on 0 AGL                            [K]
    retParams.pressureAtStaticAlt = 79900;              % the 'measured' pressure at static altitude                     [Pa]
    retParams.pressureAtGround = 101325;                % the 'measured' pressure at 0 AGL                               [Pa]

    % emperical dynamic viscosity of air
    retParams.altiBreakpoints = [0 1000 2000 3000 4000 5000 6000 7000 8000 9000];                             % altitude (ASL) breakpoints used to lookup dynamic viscosity of air    [m]
    retParams.dynamicViscosityAir = 10^(-5)*[1.789 1.758 1.726 1.694 1.661 1.628 1.595 1.561 1.527 1.493];    % dynamic viscosity table data                                          [N s/m^2]

end

end

