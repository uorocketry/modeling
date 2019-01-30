classdef SimpleEnv < Element
    %SIMPLEENV Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        % emperical wind parameters
        Z_roughness                                 % roughness length of terrain
        atmospheric_coeff                           % emperial coefficient for wind speed calculation
        
        % measured wind parameters
        referenceWindSpeed                          % the 'measured' wind speed as a reference                [m/s]
        referenceWindAltitude                       % the altitude where reference speed was 'measured'       [m]
        referenceWindAngle                          % the angle of wind (ie. encoded wind direction)          [rad]
        
        % measured static conditions used to interpolate
        referenceStaticAltitude                     % the altitude where static conditions were 'measured'    [m]
        temperatureAtStaticAlt                      % the 'measured' temperature at static altitude           [K]
        temperatureAtGround                         % the 'measured' temperature on 0 AGL                     [K]
        pressureAtStaticAlt                         % the 'measured' pressure at static altitude              [Pa]
        pressureAtGround                            % the 'measured' pressure at 0 AGL                        [Pa]
        
        % Earth params
        RADIUS_EARTH = 6371*10^3                    % radius of Earth                                         [m]
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

