classdef HybridEngine < RocketEngine
    %HybridEngine Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
    end
    
    methods
        function obj = HybridEngine(blockchoice)
            obj = obj@RocketEngine(blockchoice);
        end
        
        function initialize(obj)
            obj.assignParameters();
            obj.initialized = true;
        end
    end
end
