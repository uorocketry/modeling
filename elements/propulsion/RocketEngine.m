classdef RocketEngine < Element
    %ROCKETENGINE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
        % engine location
        X_GM                                    % engine location from nose tip                     [m]
        
        % other motor params
        Ae                                      % exit area of nozzle                               [m^2]
        Ve                                      % exit velocity of gasses out of nozzle             [m/s]
        thrustProfile                           % a thrust-time profile to describe thrust          []
        m_full                                  % full mass of motor                                [Kg]
        m_empty                                 % empty mass of motor                               [Kg]

    end
    
    methods
        function obj = RocketEngine(blockchoice)
            name = 'propulsion';
            obj = obj@Element(name, blockchoice);
            obj.libraryLoc = 'elementsLibrary/propulsion';
        end
    end
end

