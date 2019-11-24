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
        initVapMass
        initLiqMass
        liqDensity
        vapDensity
    end
    
    methods
        function obj = NitrousTank(blockchoice)
            obj = obj@PVessel(blockchoice);
        end
        
        function initialize(obj)
            obj.assignParameters();
            
            volumeTank = pi * pow((D_OxiTank/2),2) * L_OxiTank;
            bob = (1.0 / 743.9) - (1.0 / 190.0); % Need to create density interpolation (values are from nox density tables)
            
            obj.initLiqMass = (volumeTank - (obj.initOxiMass / 743.9)) / bob;
            obj.initVapMass = obj.initOxiMass - obj.initLiqMass;
            
            obj.initialized = true;
        end
    end
end
