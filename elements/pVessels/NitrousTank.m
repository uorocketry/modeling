classdef NitrousTank < PVessel
    %NitrousTank Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        % nitrous saturation pressures (C->kPa)
        temperatureBreakpoints
        pressure
        
        % nitrous density table (C->Kg/m^3)
        density
        
        % initial mass of nitrous oxide [kg]
        initOxiMass
    end
    
    methods
        function obj = NitrousTank(blockchoice)
            obj = obj@PVessel(blockchoice);
        end
        
        function initialize(obj)
            obj.assignParameters();
            obj.initialized = true;
        end
    end
end
