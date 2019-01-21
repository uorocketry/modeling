classdef SingleChute < Element
    %SINGLECHUTE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        % parachute system geometry
        d_parachute                             % parachute diameter                                            [m]
        l_riser                                 % nominal length of riser (modeling all lines)                  [m]
        X_briddle                               % location of briddle (riser connection point)                  [m]
        
        % other parachute params
        k_lines                                 % spring constant of modeled lines                              []
        c_lines                                 % damping ratio of modeled lines                                []
        c_d                                     % coefficient of drag                                           []
        mass_p                                  % mass of parachute                                             [Kg]
        
        % tumbling rocket params
        mass_r                                  % mass of tumbling rocket                                       [Kg]
        X_roff                                  % location of riser connection point to tumbling rocket body    [m]

    end
    
    methods
        function obj = SingleChute(blockchoice)
            name = 'recovery';
            obj = obj@Element(name, blockchoice);
        end
        
        function initialize(obj)
        end
    end
end

