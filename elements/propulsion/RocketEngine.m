classdef RocketEngine < Element
    %ROCKETENGINE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
        % engine location
        X_GM                                    % engine location (tip of the tank) from nose tip   [m]
        X_CG_full                               % initial location of cg of engine from X_GM        [m]
        
        % other motor params
        Ae                                      % exit area of nozzle                               [m^2]
        m_wet                                   % mass of engine with propellants                   [Kg]
        m_dry                                   % mass of engine without proellants                 [Kg]

    end
    
    methods
        function obj = RocketEngine(blockchoice)
            name = 'propulsion';
            obj = obj@Element(name, blockchoice);
            obj.libraryLoc = 'elementsLibrary/propulsion';
        end
    end
end

