classdef AeroBarrowman < Aerodynamics
    %AEROBARROWMAN Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = AeroBarrowman(blockchoice)
            obj@Aerodynamics(blockchoice);
        end
        
        function initialize(obj)
            obj.assignParameters();
            obj.initialized = true;
        end

    end
end

