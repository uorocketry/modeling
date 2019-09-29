classdef NitrousTank < PVessel
    %NitrousTank Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
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
