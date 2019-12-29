classdef NitrousTank < PVessel
    %NitrousTank Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        % nitrous saturation pressures (C->kPa)
        temperatureBreakpoints
        pressure
                
        % initial mass of nitrous oxide [kg]
        initOxiMass
        initVapMass
        initLiqMass
        
        liqDensity
        vapDensity
        delHVap
        specHeatCap
        
        % length of vent pipe [m]
        lengthVP
    end
    
    methods
        function obj = NitrousTank(blockchoice)
            obj = obj@PVessel(blockchoice);
        end
        
        function initialize(obj)
            obj.assignParameters();
            
            obj.volumeTank = pi * ((obj.D_OxiTank/2)^2) * obj.L_OxiTank;
            bob = (1.0 / 743.9) - (1.0 / 190.0); % Need to create density interpolation (values are from nox density tables)
            
            obj.initLiqMass = (obj.volumeTank - (obj.initOxiMass / 743.9)) / bob;
            obj.initVapMass = obj.initOxiMass - obj.initLiqMass;
            
            obj.initialized = true;
        end
    end
end
