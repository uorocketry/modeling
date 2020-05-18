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
        
        % initial temperature of nitrous oxide [deg c]
        initOxiTemp
        
        liqDensity
        vapDensity
        delHVap
        specHeatCap
        
        % length of vent pipe [m]
        lengthVP
        
        % important constants
        n2o_pCrit
        n2o_rhoCrit
        n2o_tCrit
        n2o_ZCrit
        n2o_gamma
    end
    
    methods
        function obj = NitrousTank(blockchoice)
            obj = obj@PVessel(blockchoice);
        end
        
        function initialize(obj)
            obj.assignParameters();
            
            % ullage is the gas head space (in our case determined by
            % the vent pipe length).
            ullageRat = obj.lengthVP/obj.L_OxiTank;
            
            initVapDensity = interp1(obj.temperatureBreakpoints,...
                                     obj.vapDensity,...
                                     obj.initOxiTemp);
            initLiqDensity = interp1(obj.temperatureBreakpoints,...
                                     obj.liqDensity,...
                                     obj.initOxiTemp);
            
            obj.volumeTank = pi * ((obj.D_OxiTank/2)^2) * obj.L_OxiTank;
            
            % Assume that perfect filling happened and no liquid went past
            % bottom of vent pipe
            obj.initVapMass = initVapDensity*ullageRat*obj.volumeTank;
            obj.initLiqMass = initLiqDensity*(1-ullageRat)*obj.volumeTank;
            obj.initOxiMass = obj.initVapMass + obj.initLiqMass;
            
            obj.initialized = true;
        end
    end
end
