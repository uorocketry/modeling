classdef SolidMotor < Element
    %SOLIDMOTOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
        % grain geometery
        d_initalgrainInner                      % grain initial inner diameter                      [m]
        d_grainOuter                            % grain outerdiameter                               [m]
        l_grain                                 % grain length                                      [m]
        
        % grain location
        X_GM                                    % grain location from nose tip                      [m]
        
        % other motor params
        Ae                                      % exit area of nozzle                               [m^2]
        Ve                                      % exit velocity of gasses out of nozzle             [m/s]
        thrustProfile                           % a thrust-time profile to describe thrust          []
        m_full                                  % full mass of motor                                [Kg]
        m_empty                                 % empty mass of motor                               [Kg]
    end
    
    methods
        function obj = SolidMotor(blockchoice)
            name = 'propulsion';
            obj = obj@Element(name, blockchoice);
        end
        
        function initialize(obj)
        end
    end
end

