classdef SimpleEnv < Element
    %SIMPLEENV Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = SimpleEnv(blockchoice)
            name = 'environment';
            obj = obj@Element(name, blockchoice);
        end
        
        function initialize(obj)
        end
    end
end

