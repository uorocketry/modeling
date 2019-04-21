classdef SingleChute < Recovery
    %SINGLECHUTE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        % parachute system geometry
        d_parachute                             % parachute diameter                                            [m]
        l_riser                                 % nominal length of riser (modeling all lines)                  [m]
        X_briddle                               % location of briddle (riser connection point)                  [m]
        surfArea_p                              % the reference surface area of the parachute                   [m^2]
        
        % other parachute params
        k_lines                                 % spring constant of modeled lines                              []
        c_lines                                 % damping ratio of modeled lines                                []
        c_dReefed                               % coefficient of drag in reefed configuration                   []
        c_dFull                                 % coefficient of drag in full configuration                     []
        mass_p                                  % mass of parachute                                             [Kg]
        inertiaMatP                             % inertia matrix of parachute                                   [Kg*m^2]
        
        % tumbling rocket params
        mass_r                                  % mass of tumbling rocket                                       [Kg]
        X_roff                                  % location of riser connection point to tumbling rocket body    [m]
        d_rocket                                % average diameter of rocket NOTE: DEFINED IN AERO AS WELL      [m]
        l_rocket                                % total length of rocket NOTE: DEFINED IN AERO AS WELL          [m]
        inertiaMatR                             % inertia matrix of tumbling rocket (modeled as cylinder)       [Kg*m^2]
        
    end
    
    methods
        function obj = SingleChute(blockchoice)
            obj = obj@Recovery(blockchoice);
        end
        
        function initialize(obj)
            obj.assignParameters();
            
            % Calculate the reference area used to compute parachute aero
            % drag force
            obj.surfArea_p = pi*((obj.d_parachute/2)^2);
            
            % Calculate the inertia matricies for both parachute and
            % tumbling rocket
            obj.inertiaMatP = [(2/3)*obj.mass_p*((obj.d_parachute/2)^2) 0                                        0;...
                               0                                        (2/3)*obj.mass_p*((obj.d_parachute/2)^2) 0;...
                               0                                        0                                        (2/3)*obj.mass_p*((obj.d_parachute/2)^2)];
            
            obj.inertiaMatR = [(0.5)*obj.mass_r*((obj.d_rocket/2)^2) 0                                                           0;...
                               0                                     (1/12)*obj.mass_r*(3*((obj.d_rocket/2)^2) + obj.l_rocket^2) 0;...
                               0                                     0                                                           (1/12)*obj.mass_r*(3*((obj.d_rocket/2)^2) + obj.l_rocket^2)];
            
            obj.initialized = true;
        end
    end
end

