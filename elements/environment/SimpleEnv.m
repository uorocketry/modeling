classdef SimpleEnv < Element
    %SIMPLEENV Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        % emperical wind parameters
        Z_roughness                                 % roughness length of terrain
        atmospheric_coeff                           % emperial coefficient for wind speed calculation
        
        % measured atmospheric parameters
        referenceWindAltitude;                      % the altitude where reference speed was 'measured'              [m]
        referenceWindSpeed;                         % the 'measured' wind speed as a reference                       [m/s]
        referenceWindAngle;                         % the angle of wind from 'x-axis (ie. encoded wind direction)    [rad]
        temperatureOffset;                          % difference in temperature from the standard atmosphere         [K]

        % parameters for atmosphere condition variation
        windSpeedVarience;                          % normal distribution varience from the reference wind speed for random wind selection      []
        windAngleVarience;                          % normal distribution varience from the reference wind angle for random wind directions     []
        temperatureVarience;                        % normal distribution varience from the temperature offset for random temperature selection []
        randomSeed;                                 % numerical random seed used to generate random noise                                       []
        
        % launch location
        launchLatitude                              % latitude of the launch site                             [rad]
        launchLongditude                            % longditude of the launch site                           [rad]
        
        % measured static conditions used to interpolate
        referenceStaticAltitude                     % the altitude where static conditions were 'measured'    [m]
        temperatureAtStaticAlt                      % the 'measured' temperature at static altitude           [K]
        temperatureAtGround                         % the 'measured' temperature on 0 AGL                     [K]
        pressureAtStaticAlt                         % the 'measured' pressure at static altitude              [Pa]
        pressureAtGround                            % the 'measured' pressure at 0 AGL                        [Pa]
        
        % emperical dynamic viscosity of air
        altiBreakpoints                             % altitude (ASL) breakpoints                              [m]
        temperatureAir                              % air temperature                                         [C]
        pressureAir                                 % air pressure                                            [Pa]
        densityAir                                  % air density                                             [kg/m^3]
        speedOfSound                                % speed of sound through atmosphere                       [m/s]
        dynamicViscosityAir                         % dynamic viscosity table data                            [N s/m^2]
        
        % Earth params
        RADIUS_EARTH = 6371*10^3                    % radius of Earth                                         [m]
        MAJOR_RADIUS_EARTH = 6378137.0              % WGS-84 ellipsoid, semi-minor axis                       [m]
        MINOR_RADIUS_EARTH = 6356752.3              % WGS-84 ellipsoid, semi-major axis                       [m]
        MASS_EARTH = 5.972*10^24                    % mass of Earth                                           [kg]
        ANGULARVELOCITY_EARTH = 7.2921159*10^(-5)   % angular velocity of Earth                               [rad/s]
        
        % Other environmental constants
        GRAVITATION_CONST = 6.67408*10^(-11)         % universal gravitation constant                         [m^3*/(kg*s^2)]
        
    end
    
    methods
        function obj = SimpleEnv(blockchoice)
            name = 'environment';
            obj = obj@Element(name, blockchoice);
            obj.libraryLoc = 'elementsLibrary/environment';
        end
        
        function initialize(obj)
            obj.assignParameters();
            obj.initialized = true;
        end
    end
end

