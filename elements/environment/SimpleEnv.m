classdef SimpleEnv < Element
    %SIMPLEENV Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        % emperical wind parameters
        Z_roughness                                 % roughness length of terrain
        
        % Earth params
        radius_Earth = 6371*10^3                    % radius of Earth                       [m]
        mass_Earth = 5.972*10^24                    % mass of Earth                         [kg]
        angularVelocity_Earth = 7.2921159*10^(-5)   % angular velocity of Earth             [rad/s]
        
        % Other environmental constants
        graviation_const = 6.67408*10^(-11)         % universal gravitation constant        [m^3*/(kg*s^2)]
        
    end
    
    methods
        function obj = SimpleEnv(blockchoice)
            name = 'environment';
            obj = obj@Element(name, blockchoice);
        end
        
        function initialize(obj)
        end
    end
end

