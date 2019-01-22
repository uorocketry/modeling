classdef SolidMotor < RocketEngine
    %SOLIDMOTOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
        % grain geometery
        d_initalgrainInner                      % grain initial inner diameter                      [m]
        d_grainOuter                            % grain outerdiameter                               [m]
        l_grain                                 % grain length                                      [m]
        
    end
    
    methods
        function obj = SolidMotor(blockchoice)
            obj = obj@RocketEngine(blockchoice);
        end
        
        function initialize(obj)
        end
    end
end

